#!/usr/bin/env ./script/runner

require "pp"
require "rubygems"
require "rscm"
require "rexml/document"

ENV['PATH'] = "/usr/local/bin:#{ENV['PATH']}"
ENV['PKG_CONFIG_PATH'] = "/usr/local/lib/pkgconfig:/usr/lib/pkgconfig"

@@testrun = nil
@@log = ""
@@buildcmd = <<BUILD
./runprebuild.sh
nant clean
nant test-xml
BUILD


def get_source(rev)
    # get the repo object
    repo = rev.repo.rscm
    
    repo.checkout_dir = rev.builddir

    # time based checkouts for subversion, identifiers for git
    if repo.is_a?(RSCM::Git)
        repo.checkout(rev.identifier)
    else
        repo.checkout(rev.time)
    end
    
    return rev.builddir
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
        IO.popen("#{cmdline} 2>&1") do |output|
            loglines output
        end
        # we failed during the command
        if $? != 0
            failmsg = "FAILED on command '#{cmdline}'"
            @@testrun.log += failmsg
            raise failmsg
        end
    end
   
    collect_tests(testdir)
    
    if $? != 0
        raise "failed to run build"
     end
end

def clear_tests(testdir)
    FileUtils.rm_rf testdir
end


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
        @@testrun.job_id = job.id
        @@testrun.save
    end
end

def main
    rev = Revision.find(ARGV[0])
    @@testrun = rev.test_runs.build
    @@testrun.log = ""
    # this creates the start time
    @@testrun.save
    begin
        # first, back reference ourselves
        get_jobid
        
        dir = get_source(rev)
        
        testdir = "#{dir}/test-results"
        clear_tests(testdir)
      
        @@testrun.starttime = DateTime.now
      
        pass = do_run(dir, @@buildcmd)
        collect_tests(testdir)
        
        @@testrun.endtime = DateTime.now
        
        @@testrun.success = true
        @@testrun.save
        # if we are succesful, remove the builddir
        FileUtils.rm_rf(dir, :secure => true)
        
    rescue => e
        puts e
        @@testrun.endtime = DateTime.now
        collect_tests(testdir)
        @@testrun.success = false
        @@testrun.save
    end
end

main
