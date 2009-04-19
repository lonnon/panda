#!/usr/bin/env ./script/runner

require "rubygems"
require "rscm"
require "rexml/document"

@@testrun = nil
@@log = ""

def get_source(rev)
    # get the repo object
    repo = rev.repo.rscm
    
    dir = "#{rev.repo.builddir}/#{rev.repo.name}-#{rev.identifier}"
    repo.checkout_dir = dir

    # this is a little weird, but to get the right rev we need to do time based checkouts
    repo.checkout(rev.time)
    
    return dir
end

def do_build(dir)
    # now we do the build
    Dir.chdir(dir)
    
    testdir = "test-results"
    FileUtils.rm_rf testdir
    
    IO.popen("./runprebuild.sh") {|f|
        f.lines.each do |line|
            puts line
            @@log += line
        end
    }
    
    if $? != 0
        raise "failed to run prebuild"
    end
    
    IO.popen("make test-xml") {|f|
        f.lines.each do |line|
            puts line
            @@log += line
        end
    }

    collect_tests(testdir)
    
    if $? != 0
        raise "failed to run build"
     end
end

def collect_tests(testdir)
    begin
        total = 0
        failed = 0
        skipped = 0
        
        Dir.foreach(testdir) do |x|
            if x =~ /\.xml$/ 
                file = "#{testdir}/#{x}"
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
        @@testrun.passed = total - failed - skipped 
        @@testrun.failed = failed
        @@testrun.skipped = skipped
        @@testrun.save
                
    rescue => e
        puts e
    end
end

def main
    rev = Revision.find(ARGV[0])
    @@testrun = rev.test_runs.build
    # this creates the start time
    @@testrun.save
    begin
        dir = get_source(rev)
        pass = do_build(dir)
        @@testrun.success = true
        @@testrun.log = @@log
        @@testrun.save
    rescue => e
        puts e
        @@testrun.success = false
        @@testrun.log = @@log
        @@testrun.save
    end
end

main