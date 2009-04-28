class AddIndexesToTestRuns < ActiveRecord::Migration
    def self.up
        add_index :test_runs, :revision_id
        add_index :test_runs, :job_id
    end
    
    def self.down
    end
end
