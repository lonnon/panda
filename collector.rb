#!/usr/bin/env ./script/runner

repos = Repo.find(:all)

repos.each do |repo|
    latest = repo.gather_revs
    puts "Latest = #{latest}"
    
    if latest != nil
        puts "Bj.submit './builder.rb #{latest}'"
        Bj.submit "./builder.rb #{latest}"
    end
end
