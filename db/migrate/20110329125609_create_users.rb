class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :picture_url
      t.string :link
      t.column  :facebook_id, :bigint
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
