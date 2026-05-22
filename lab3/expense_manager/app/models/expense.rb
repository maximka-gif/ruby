class Expense < ApplicationRecord
    enum :status, { planned: 0, paid: 1, cancelled: 2 }, default: :planned
  
    validates :title, :amount, :date, presence: true
  end