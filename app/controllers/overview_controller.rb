class OverviewController < ApplicationController
    def index
        @test = TestRun.find(:first, :conditions => ["job_id is not null"], :order => "id desc")
        @job = @test.job
        @revs = Array.new
        Repo.find(:all).each do |repo|
            @revs << repo.revisions.find(:all, :limit => 20, :order => "time desc").select {|r| r.test_runs.length > 0}
            @revs.flatten!
        end
        @revs.sort_by {|r| r.time}
    end
end
