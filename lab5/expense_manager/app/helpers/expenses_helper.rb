module ExpensesHelper
    def amount_badge(expense)
      amount = expense.amount

      css_class = if amount < 500
                    "badge bg-success"
      elsif amount < 5000
                    "badge bg-warning text-dark"
      else
                    "badge bg-danger"
      end

      formatted_amount = format("%.2f", amount)
      content_tag(:span, "#{formatted_amount} грн", class: css_class)
    end
end
