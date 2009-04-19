class CreateTestRuns < ActiveRecord::Migration
  def self.up
    create_table :test_runs do |t|
      t.integer :revision_id
      t.text :log
      t.text :rawtest
      t.boolean :success
      t.integer :passed
      t.integer :skipped
      t.integer :failed

      t.timestamps
    end
  end

  def self.down
    drop_table :test_runs
  end
end
