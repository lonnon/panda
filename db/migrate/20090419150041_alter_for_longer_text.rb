class AlterForLongerText < ActiveRecord::Migration
    def self.up
        # this bumps col from TEXT to MEDIUMTEXT in mysql
        change_column :bj_job, :stdin, :text, :limit => 64.kilobytes + 1
        change_column :bj_job_archive, :stdin, :text, :limit => 64.kilobytes + 1
        change_column :test_runs, :log, :text, :limit => 64.kilobytes + 1
        change_column :test_runs, :rawtest, :text, :limit => 64.kilobytes + 1
    end
    
    def self.down
        # this bumps col from MEDIUMTEXT to TEXT in mysql
        change_column :bj_job, :stdin, :text
        change_column :bj_job_archive, :stdin, :text
        change_column :test_runs, :log, :text
        change_column :test_runs, :rawtest, :text
    end
end

