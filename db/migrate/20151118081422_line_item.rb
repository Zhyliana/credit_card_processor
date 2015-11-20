class LineItem < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :credit_card_id, null: false
      t.integer :amount,         null: false

      t.timestamps  null: false
    end

    add_index :line_items, :credit_card_id
  end
end
