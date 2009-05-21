class AddBuilddirToTestRun < ActiveRecord::Migration
    def self.up
        add_column :test_runs, :builddir, :string
    end
    
    def self.down
    end
end
