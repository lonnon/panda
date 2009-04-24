class TestRun < ActiveRecord::Base
    belongs_to :revision
    
    def job
        Bj.table.job.find(job_id)
    end
end
