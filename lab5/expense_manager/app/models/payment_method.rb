class PaymentMethod < ApplicationRecord
    belongs_to :expense, optional: true
  end