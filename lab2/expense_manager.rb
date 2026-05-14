require 'json'
require 'yaml'
require_relative 'expense'

class ExpenseManager
  attr_reader :collection

  def initialize
    @collection = {}
  end

  def add(expense)
    id = (@collection.keys.max || 0) + 1
    @collection[id] = expense
    puts "Витрату успішно додано з ID #{id}!"
  end

  def show_all
    if @collection.empty?
      puts "Список витрат порожній."
      return
    end

    @collection.each do |id, expense|
      puts "[#{id}] #{expense}"
    end
  end

  def delete(id)
    if @collection[id]
      @collection.delete(id)
      puts "Запис з ID #{id} видалено."
    else
      puts "Помилка: Запис не знайдено."
    end
  end

  def edit_expense(id)
    expense = @collection[id]

    if expense.nil?
      puts "Помилка: Запис не знайдено."
      return
    end

    puts "Залишайте поле порожнім (просто натисніть Enter), якщо не хочете його змінювати."

    puts "Нова назва (# {expense.title}):"
    value = gets.chomp.strip
    expense.title = value unless value.empty?

    puts "Нова сума (# {expense.amount}):"
    value = gets.chomp.strip
    unless value.empty?
      expense.amount = value.to_f if value.to_f >= 0
    end

    puts "Новий статус (planned/paid/cancelled/ongoing/completed):"
    value = gets.chomp.strip.downcase
    unless value.empty?
      if Expense.valid_status?(value)
        expense.status = value
      else
        puts "Невірний статус, залишено старий."
      end
    end

    puts "Запис оновлено."
  end

  def find_by_title(text)
    result = @collection.select { |_, e| e.title.downcase.include?(text.downcase) }
    print_collection(result)
  end

  def filter_by_category(category)
    result = @collection.select { |_, e| e.categories.map(&:downcase).include?(category.downcase) }
    print_collection(result)
  end

  def filter_by_status(status)
    result = @collection.select { |_, e| e.status.downcase == status.downcase }
    print_collection(result)
  end

  def total_amount
    total = @collection.sum { |_, e| e.amount }
    puts "Загальна сума всіх витрат: #{total} грн"
  end

  def print_collection(collection)
    if collection.empty?
      puts "Нічого не знайдено."
      return
    end
    collection.each { |id, expense| puts "[#{id}] #{expense}" }
  end

  def save_to_yaml(file)
    File.write(file, YAML.dump(@collection))
  end

  def load_from_yaml(file)
    @collection = YAML.load_file(file) || {}
  rescue Errno::ENOENT
    @collection = {}
  end

  def save_to_json(file)
    data = @collection.transform_values(&:to_h)
    File.write(file, JSON.pretty_generate(data))
  end

  def load_from_json(file)
    data = JSON.parse(File.read(file))
    @collection = data.transform_keys(&:to_i).transform_values { |v| Expense.from_h(v) }
  rescue Errno::ENOENT
    @collection = {}
  end
end