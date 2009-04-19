class AddBuildDirToRepo < ActiveRecord::Migration
    def self.up
        add_column :repos, :builddir, :string, :default => "/tmp/"
    end
    
    def self.down
    end
end
