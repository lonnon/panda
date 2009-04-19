#!/usr/bin/env ./script/runner

require "rubygems"
require "rscm"
require "rexml/document"

BaseDir = "/tmp/"

@@testrun = nil
@@log = ""

def get_source(rev)
    # get the repo object
    repo = rev.repo.rscm
    
    dir = BaseDir + "#{rev.repo.name}-#{rev.identifier}"
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
            @@log += line
        end
    }
    
    if $? != 0
        return false
    end
    
    IO.popen("make test-xml") {|f|
        f.lines.each do |line|
            @@log += line
        end
    }
    
    if $? != 0
        return false
     end
    
    return true
end

def create_report 
    Dir.foreach(testdir) do |x|
        if x =~ /\.xml$/ 
            file = "#{testdir}/#{x}"
            doc = REXML::Document.new File.new file
            puts doc.root.attribute :name
            puts doc.root.attribute :total
            puts doc.root.attribute :failures
            puts doc.root.attribute "not-run"
        end
    end
end

def main
    rev = Revision.find(ARGV[0])
    @@testrun = rev.testruns.build
    # this creates the start time
    @@testrun.save
    
    puts rev.message
    dir = get_source(rev)
    # pass = do_build(dir)
    # puts pass
end

main
