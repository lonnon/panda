class OverviewController < ApplicationController
    def index
        @test = TestRun.find(:first, :order => "id desc")
        @job = @test.job
        @revs = Revision.find(:all, :limit => 20, :order => "id desc").select {|r| r.test_runs.length > 0}
    end
end
