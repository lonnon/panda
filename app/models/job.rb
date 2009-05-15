class Job < ActiveRecord::Base
    # this is used to get access to older jobs
    set_table_name "bj_job_archive"
    set_primary_key "bj_job_archive_id"
    
        
    def find(job_id)
        begin
            return Bj.table.job.find(job_id)
        rescue => e
            begin 
                return find(job_id)
            rescue => e
            end
            return nil
        end
    end
end
