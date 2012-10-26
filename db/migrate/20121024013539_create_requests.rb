class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :promoter_id
      t.references :user
      t.integer :state, default: 0, limit: 6

      t.timestamps
    end
    add_index :requests, :promoter_id
    add_index :requests, :user_id
  end
end
