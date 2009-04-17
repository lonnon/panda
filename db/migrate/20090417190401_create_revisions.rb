class CreateRevisions < ActiveRecord::Migration
    def self.up
        create_table :revisions do |t|
            t.integer :repo_id
            t.string :identifier
            t.datetime :time
            t.string :message
            t.string :developer
            
            t.timestamps
        end
        add_index :revisions, :identifier
        add_index :revisions, :repo_id
    end
    
    def self.down
        drop_table :revisions
    end
end
