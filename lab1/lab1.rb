require 'json'
require 'yaml'

STATUSES = ['planned', 'paid', 'cancelled', 'ongoing', 'completed']


def add_expense(expenses, title, categories, payment_methods, amount, date, notes, status)
  id = expenses.empty? ? 1 : expenses.keys.max.to_i + 1

  unless STATUSES.include?(status)
    puts "Помилка: Неприпустимий статус '#{status}'. Запис не додано."
    return expenses
  end

  expenses[id] = {
    title: title,
    categories: categories,
    payment_methods: payment_methods,
    amount: amount.to_f,
    date: date,
    notes: notes,
    status: status
  }
  
  puts "Витрату '#{title}' успішно додано з ID #{id}."
  expenses
end

def edit_expense(expenses, id, new_data)
  if expenses[id]
    expenses[id].merge!(new_data)
    puts "Запис з ID #{id} успішно оновлено."
  else
    puts "Помилка: Витрату з ID #{id} не знайдено."
  end
  expenses
end

def delete_expense(expenses, id)
  if expenses.key?(id)
    expenses.delete(id)
    puts "Запис з ID #{id} успішно видалено."
  else
    puts "Помилка: Витрату з ID #{id} не знайдено."
  end
  expenses
end

def list_expenses(expenses)
  if expenses.empty?
    puts "Список витрат порожній."
    return
  end
  
  puts "\n--- СПИСОК ВИТРАТ ---"
  expenses.each do |id, e|
    puts "[#{id}] #{e[:title]} | Категорії: #{e[:categories].join(', ')} | Спосіб оплати: #{e[:payment_methods].join(', ')} | Сума: #{e[:amount]} грн | Дата: #{e[:date]} | Статус: #{e[:status]} | Нотатки: #{e[:notes]}"
  end
  puts "---------------------\n"
end



def find_by_title(expenses, part_title)
  expenses.select do |_, e|
    e[:title].downcase.include?(part_title.downcase)
  end
end

def filter_by_category(expenses, category)
  expenses.select do |_, e|
    e[:categories].map(&:downcase).include?(category.downcase)
  end
end

def filter_by_status(expenses, status)
  expenses.select do |_, e|
    e[:status].downcase == status.downcase
  end
end

def total_amount(expenses)
  total = expenses.sum { |_, e| e[:amount] }
  total
end



def save_to_json(expenses, filename)
  File.write(filename, JSON.pretty_generate(expenses))
  puts "Дані успішно збережено у JSON файл: #{filename}"
rescue => e
  puts "Помилка під час збереження у JSON: #{e.message}"
end

def load_from_json(filename)
  data = JSON.parse(File.read(filename))
  
  data.transform_keys(&:to_i).transform_values do |v|
    v.transform_keys(&:to_sym)
  end
rescue Errno::ENOENT
  puts "Помилка: Файл #{filename} не знайдено. Створено порожню колекцію."
  {}
end

def save_to_yaml(expenses, filename)
  File.write(filename, expenses.to_yaml)
  puts "Дані успішно збережено у YAML файл: #{filename}"
rescue => e
  puts "Помилка під час збереження у YAML: #{e.message}"
end

def load_from_yaml(filename)
  data = YAML.load_file(filename) || {}
  
  data.transform_keys(&:to_i).transform_values do |v|
    v.transform_keys(&:to_sym)
  end
rescue Errno::ENOENT
  puts "Помилка: Файл #{filename} не знайдено. Створено порожню колекцію."
  {}
end



my_expenses = {
  1 => {
    title: "Продукти",
    categories: ["Їжа", "Побут"],
    payment_methods: ["Готівка", "Картка"],
    amount: 450.50,
    date: "2024-03-01",
    notes: "Покупка в супермаркеті",
    status: "paid" 
  },
  2 => {
    title: "Оренда офісу",
    categories: ["Бізнес"],
    payment_methods: ["Картка"],
    amount: 15000.00,
    date: "2024-03-05",
    notes: "Щомісячна оплата",
    status: "planned" 
  }
}

puts "\n--- Тестування методів ---"

add_expense(
  my_expenses,
  "Квитки на поїзд",
  ["Транспорт", "Подорожі"],
  ["Картка"],
  850.00,
  "2024-03-10",
  "Поїздка до Києва",
  "paid"
)

list_expenses(my_expenses)

edit_expense(my_expenses, 1, { amount: 500.00, notes: "Сільпо" })

puts "\n--- Результати пошуку ---"
puts "Пошук слова 'оренда':"
p find_by_title(my_expenses, "оренда")

puts "\nФільтр за категорією 'Транспорт':"
p filter_by_category(my_expenses, "Транспорт")

puts "\nФільтр за статусом 'paid':"
p filter_by_status(my_expenses, "paid")

puts "\nЗагальна сума витрат: #{total_amount(my_expenses)} грн"

delete_expense(my_expenses, 2)
delete_expense(my_expenses, 99) 

save_to_json(my_expenses, "expenses.json")
loaded_json = load_from_json("expenses.json")
puts "\nЗавантажена назва з JSON (ID 1): #{loaded_json[1][:title]}"

save_to_yaml(my_expenses, "expenses.yaml")
loaded_yaml = load_from_yaml("expenses.yaml")
puts "Завантажена сума з YAML (ID 3): #{loaded_yaml[3][:amount]}"

load_from_json("fake_file.json")