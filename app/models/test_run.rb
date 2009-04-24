class TestRun < ActiveRecord::Base
    belongs_to :revision
    
    def job
        begin
            return Bj.table.job.find(job_id)
        rescue => e
            return nil
        end
    end
end
