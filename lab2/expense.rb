class Expense
    STATUSES = ["planned", "paid", "cancelled", "ongoing", "completed"]
  
    attr_accessor :title, 
                  :categories, 
                  :payment_methods, 
                  :amount, 
                  :date, 
                  :notes, 
                  :status
  
    def initialize(title, categories, payment_methods, amount, date, notes, status = "planned")
      @title = title
      @categories = categories
      @payment_methods = payment_methods
      @amount = amount.to_f
      @date = date
      @notes = notes
  
      if Expense.valid_status?(status)
        @status = status
      else
        @status = "planned"
      end
    end
  
    def self.valid_status?(status)
      STATUSES.include?(status)
    end
  
    def to_s
      "#{title} | Категорії: #{categories.join(', ')} | Оплата: #{payment_methods.join(', ')} | Сума: #{amount} грн | Дата: #{date} | Статус: #{status} | Нотатки: #{notes}"
    end
  
    def to_h
      {
        title: @title,
        categories: @categories,
        payment_methods: @payment_methods,
        amount: @amount,
        date: @date,
        notes: @notes,
        status: @status
      }
    end
  
    def self.from_h(hash)
      new(
        hash["title"] || hash[:title],
        hash["categories"] || hash[:categories],
        hash["payment_methods"] || hash[:payment_methods],
        hash["amount"] || hash[:amount],
        hash["date"] || hash[:date],
        hash["notes"] || hash[:notes],
        hash["status"] || hash[:status]
      )
    end
  end