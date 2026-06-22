class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_cents, null: false, default: 0
      t.string :status, null: false, default: "placed"
      t.string :customer_name, null: false
      t.text :shipping_address, null: false

      t.timestamps
    end
  end
end
