class Job < ActiveRecord::Base
    # this is used to get access to older jobs
    set_table_name "bj_job_archive"
    set_primary_key "bj_job_archive_id"
    
end
