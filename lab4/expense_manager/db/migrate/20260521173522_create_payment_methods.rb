class CreatePaymentMethods < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.integer :expense_id

      t.timestamps
    end
  end
end
