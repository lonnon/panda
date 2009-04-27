class TestRun < ActiveRecord::Base
    belongs_to :revision
    
    def job
        begin
            return Bj.table.job.find(job_id)
        rescue => e
            begin 
                return Bj.table.job_archive(job_id)
            rescue => e
            end
            return nil
        end
    end
end
