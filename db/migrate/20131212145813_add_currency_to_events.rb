class AddCurrencyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :currency, :string, default: "USD"
  end
end
