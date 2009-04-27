class IncreaseLogSize < ActiveRecord::Migration
    def self.up
        change_column :bj_job, :stdout, :text, :limit => 1.megabyte
        change_column :bj_job_archive, :stdout, :text, :limit => 1.megabyte
        change_column :bj_job, :stderr, :text, :limit => 1.megabyte
        change_column :bj_job_archive, :stderr, :text, :limit => 1.megabyte
    end
    
    def self.down
        change_column :bj_job, :stdout, :text
        change_column :bj_job_archive, :stdout, :text
        change_column :bj_job, :stderr, :text
        change_column :bj_job_archive, :stderr, :text
    end
end
