class CreateTestSets < ActiveRecord::Migration
    def self.up
        create_table :test_sets do |t|
            t.string :name
            t.integer :repo_id
            t.integer :procedure_id
            t.integer :environment_id
            t.timestamps
        end
    end
    
    def self.down
        drop_table :test_sets
    end
end
