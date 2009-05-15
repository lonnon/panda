class OverviewController < ApplicationController
    def index
        @test = TestRun.find(:first, :conditions => ["job_id is not null"], :order => "id desc")
        if @test
            begin 
                @job = Bj.table.job.find(@test.job_id)
            rescue => e
                # we didn't find the job, who cares
            end
        end
        @revs = []
        Repo.find(:all).each do |repo|
            @revs << repo.revisions.find(:all, :limit => 20, :order => "time desc").select {|r| r.test_runs.length > 0}
            @revs.flatten!
        end
        @revs.sort_by {|r| r.time}
    end
end
