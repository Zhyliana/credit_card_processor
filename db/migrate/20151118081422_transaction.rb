class Transaction < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :credit_card_id, null: false
      t.integer :amount,         null: false

      t.timestamps  null: false
    end

    add_index :transactions, :credit_card_id
  end
end
