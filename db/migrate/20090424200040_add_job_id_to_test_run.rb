class AddJobIdToTestRun < ActiveRecord::Migration
    def self.up
        add_column :test_runs, :job_id, :integer
    end
    
    def self.down
    end
end
