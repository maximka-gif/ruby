class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.string :title
      t.string :category
      t.float :amount
      t.date :date
      t.text :notes
      t.string :payment_method
      t.integer :status

      t.timestamps
    end
  end
end
