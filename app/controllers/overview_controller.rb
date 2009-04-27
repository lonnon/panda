class OverviewController < ApplicationController
    def index
        @job = last_job
        @test = TestRun.find_by_job_id(@job.id)
        @revs = Revision.find(:all, :limit => 20, :order => "id desc").select {|r| r.test_runs.length > 0}
    end
    
    private
   
    def last_job
        job = nil
        jobs = Bj.table.job.find(:all)
        if jobs.length > 0
            if jobs.length == 1
                return job = jobs[-1]
            else
                offset = -1
                while((jobs[offset].state != "running") or (jobs[offset].state != "finished")) 
                    offset -= 1
                end
                return jobs[offset]
            end
        end
        
        jobs = Bj.table.job_archive.find(:all)
        if jobs.length > 0
            return job = jobs[-1]
        end
        
        return job
    end
    
end
