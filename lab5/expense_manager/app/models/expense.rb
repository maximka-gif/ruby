class Expense < ApplicationRecord
    enum :status, { planned: 0, paid: 1, cancelled: 2 }, default: :planned
  
    validates :title, :amount, :date, presence: true
  
    scope :paid_expenses, -> { where(status: :paid) }
    scope :planned_expenses, -> { where(status: :planned) }
  
    scope :large, -> { where("amount >= ?", 5000) }
  
    scope :this_month, -> {
      where(date: Time.current.beginning_of_month..Time.current.end_of_month)
    }
  end