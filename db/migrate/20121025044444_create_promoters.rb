class CreatePromoters < ActiveRecord::Migration
  def change
    create_table :promoters do |t|
      t.references :user
      t.integer :state, default: 0, limit: 4
      t.boolean :visible, default: false
      t.string :encrypted_api_key
      t.string :promoter_name
      t.string :image
      t.string :available
      t.string :fee
      t.string :quick_profile
      t.string :about
      t.string :equipment
      t.string :venues
      t.string :travel
      t.string :accomodation
      t.string :support

      t.timestamps
    end
    add_index :promoters, :user_id
  end
end
