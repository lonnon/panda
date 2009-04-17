class CreateRepos < ActiveRecord::Migration
  def self.up
    create_table :repos do |t|
      t.string :url
      t.string :name
      t.string :rtype
      t.datetime :last_checked

      t.timestamps
    end
  end

  def self.down
    drop_table :repos
  end
end
