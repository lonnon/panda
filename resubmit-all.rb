#!/usr/bin/env ./script/runner

repos = Repo.find(:all)

repos.each do |repo|
    revs = repo.revisions.find(:all, :conditions => ["time > ?", 3.days.ago])
    
    revs.each do |rev|
	FileUtils.rm_rf(rev.builddir)
        rev.test_runs.each do |test|
            if test.builddir
                FileUtils.rm_rf(rev.builddir)
            end
        end
 	rev.test_runs.destroy_all
        puts "Bj.submit './builder.rb #{rev.id}'"
        Bj.submit "./builder.rb #{rev.id}"
    end
end
