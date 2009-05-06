class RevisionMessageToText < ActiveRecord::Migration
    def self.up
        change_column :revisions, :message, :text
    end
    
    def self.down
    end
end

