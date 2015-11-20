class CreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string  :given_name,  null: false
      t.string  :card_number, null: false, limit: 19, unique: true
      t.integer :limit,       null: false

      t.timestamps            null: false
    end

    add_index :credit_cards, :card_number, unique: true
  end
end
