class LineItem < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.belongs_to :credit_card
      t.integer :amount,  null: false

      t.timestamps  null: false
    end

    add_index :line_items, :credit_card_id
  end
end
