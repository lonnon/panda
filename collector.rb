#!/usr/bin/env ./script/runner

repos = Repo.find(:all)

repos.each do |repo|
    latest = repo.gather_revs
    puts "Latest = #{latest}"
    
    rev = Revision.find_by_identifier(latest)
    
    if latest != nil
        puts "Bj.submit './builder.rb #{rev.id}'"
        Bj.submit "./builder.rb #{rev.id}"
    end
end
