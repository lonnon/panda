class CreateProcedures < ActiveRecord::Migration
    def self.up
        create_table :procedures do |t|
            t.string :name
            t.text :commands
            t.string :analyzer
            t.timestamps
        end
    end

    def self.down
        drop_table :procedures
    end
end
