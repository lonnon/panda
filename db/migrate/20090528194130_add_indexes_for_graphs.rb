class AddIndexesForGraphs < ActiveRecord::Migration
    def self.up
        add_index :test_sets, :procedure_id
        add_index :test_sets, :repo_id
        add_index :test_sets, :environment_id
        add_index :revisions, :time
        add_index :test_runs, :test_set_id
    end
    
    def self.down
    end
end
