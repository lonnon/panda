#!/usr/bin/env ./script/runner

require "pp"
require "rubygems"
require "rscm"
require "rexml/document"

def get_source(test)
    # get the repo object
    repo = test.revision.repo.rscm
        
    repo.checkout_dir = test.builddir

    # time based checkouts for subversion, identifiers for git
    if repo.is_a?(RSCM::Git)
        repo.checkout(test.revision.identifier)
    else
        repo.checkout(test.revision.time)
    end
    
    return test.builddir
end

def loglines(f)
    begin
        count = 0
        while true
            line = f.readline
            puts line
            @@testrun.log += line
            count += 1
            if (count % 10) == 0
                @@testrun.save
            end
        end
    rescue EOFError
    end
    @@testrun.save
end

def env_dump
    puts ""
    puts "Running tests under the following environment:"
    pp ENV
    puts ""
    
    IO.popen("mono --version 2>&1") {|f|
        loglines(f)
    }
    puts ""
end

def do_run(dir, cmd)
    # now we do the build
    Dir.chdir(dir)
    env_dump
    
    cmd.lines.each do |cmdline|
        # the strip is really important, otherwise this doesn't do what you think it will do
        IO.popen("#{cmdline.strip} 2>&1") do |output|
            loglines output
        end
        # we failed during the command
        if $? != 0
            failmsg = "FAILED on command '#{cmdline}'"
            @@testrun.log += failmsg
            raise failmsg
        end
    end
end

def clear_tests(testdir)
    FileUtils.rm_rf testdir
end


# this needs to be moved off into some nunit specific code path
def collect_tests(testdir)
    begin
        total = 0
        failed = 0
        skipped = 0
        @@testrun.rawtest = ""
        Dir.foreach(testdir) do |x|
            if x =~ /\.xml$/ 
                file = "#{testdir}/#{x}"
                
                File.open(file, "r") do |f|
                    while (line = f.gets) 
                        @@testrun.rawtest += line
                    end
                end
                
                doc = REXML::Document.new File.new file
                # puts doc.root.attribute :name ok, a little wierd,
                # but ruby is strongly typed, and attributes only know
                # how to become strings, but from a string we can get
                # to an int.
                total += doc.root.attribute(:total).to_s.to_i
                failed += doc.root.attribute(:failures).to_s.to_i
                skipped += doc.root.attribute("not-run").to_s.to_i
            end
        end
        @@testrun.passed = total - failed
        @@testrun.failed = failed
        @@testrun.skipped = skipped
        @@testrun.save
                
    rescue => e
        puts e
    end
end

def get_jobid
    job = Bj.table.job.find(:first, :conditions => ["state = ?", "running"])
    if job
        return job.id
    else
        return nil
    end
end

def init_testrun(set, rev)
    set.environment.variables.split(/[\n\r]/).each do |line|
        if line =~ /^(.*?)=(.*)/
            puts "Setting #{$1} => #{$2}"
            ENV[$1] = $2
        end
    end
        
    testrun = set.test_runs.build
    testrun.revision_id = rev.id
    testrun.log = ""
    testrun.rawtest = ""
    testrun.builddir = "#{rev.builddir}-#{set.id}"
    testrun.job_id = get_jobid
    testrun.save
    return testrun
end

def main
    @rev = Revision.find(ARGV[0])
    @repo = @rev.repo
    @repo.test_sets.each do |set|
        @@testrun = init_testrun(set, @rev)
        env_dump
        
        begin
            get_source(@@testrun)
        
            @testdir = "#{@@testrun.builddir}/test-results"
            clear_tests(@testdir)
      
            @@testrun.starttime = DateTime.now
      
            pass = do_run(@@testrun.builddir, set.procedure.commands)
            collect_tests(@testdir)
        
            @@testrun.endtime = DateTime.now
            
            @@testrun.success = true
            @@testrun.save
            # if we are succesful, remove the builddir
            FileUtils.rm_rf(@@testrun.builddir, :secure => true)
            
        rescue => e
            puts e
            @@testrun.endtime = DateTime.now
            collect_tests(@testdir)
            @@testrun.success = false
            @@testrun.save
        end
    end
end

main
