class DropCarts < ActiveRecord::Migration
  def up
    drop_table :carts
  end
  def down
      raise ActiveRecord::IrreversibleMigration
  end
end
