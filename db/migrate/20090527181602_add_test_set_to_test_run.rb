class AddTestSetToTestRun < ActiveRecord::Migration
    def self.up
        add_column :test_runs, :test_set_id, :integer
    end
    
    def self.down
    end
end
