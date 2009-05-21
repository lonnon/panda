class AddStartEndTimesToTestRun < ActiveRecord::Migration
    def self.up
        add_column :test_runs, :starttime, :datetime
        add_column :test_runs, :endtime, :datetime
    end
    
    def self.down
    end
end
