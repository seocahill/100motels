class CreatePromoters < ActiveRecord::Migration
  def change
    create_table :promoters do |t|
      t.user :references
      t.integer :state
      t.string :promoter_name

      t.timestamps
    end
  end
end
