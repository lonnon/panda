#!/usr/bin/env ./script/runner

# build repo

repo = Repo.find_by_name("opensim-trunk")
if not repo 
    repo = Repo.new
end
repo.name = "opensim-trunk"
repo.url = "http://opensimulator.org/svn/opensim/trunk"
repo.rtype = "svn"
repo.save

proc = Procedure.find_by_name("opensim unit tests")
if not proc
    proc = Procedure.new
end
proc.name = "opensim unit tests"
proc.commands = <<BUILD
./runprebuild.sh
nant clean
nant test-xml
BUILD
proc.analyzer = "nunit"
proc.save

["2.0.1", "2.2", "2.4"].each do |ver|
    env = Environment.find_by_name("mono #{ver}")
    if not env 
        env = Environment.new
    end
    env.name = "mono #{ver}"
    env.variables = <<ENV
PATH=/usr/local/mono-#{ver}/bin:/bin:/usr/bin:/usr/local/bin
PKG_CONFIG_PATH=/usr/local/mono-#{ver}/lib/pkgconfig:/usr/lib/pkgconfig:/usr/local/lib/pkgconfig
ENV
    env.save
    
    set = TestSet.find_by_name("unit tests for mono #{ver}")
    if not set
        set = TestSet.new
    end
    set.name = "unit tests for mono #{ver}"
    set.environment_id = env.id
    set.procedure_id = proc.id
    set.repo_id = repo.id
    set.save
end

