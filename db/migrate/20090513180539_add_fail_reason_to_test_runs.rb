class AddFailReasonToTestRuns < ActiveRecord::Migration
    def self.up
        add_column :test_runs, :fail_reason, :string
    end
    
    def self.down
    end
end
