require_relative 'expense_manager'

manager = ExpenseManager.new

begin
  if File.exist?("expenses.yaml")
    manager.load_from_yaml("expenses.yaml")
    puts "Дані завантажено з YAML."
  elsif File.exist?("expenses.json")
    manager.load_from_json("expenses.json")
    puts "Дані завантажено з JSON."
  else
    puts "Починаємо з порожнього списку."
  end
rescue => e
  puts "Помилка завантаження: #{e.message}"
end

# ---------- ГОЛОВНЕ МЕНЮ ----------
begin
  loop do
    puts "\n=== МЕНЮ ==="
    puts "1. Додати витрату"
    puts "2. Показати всі витрати"
    puts "3. Редагувати витрату"
    puts "4. Видалити витрату"
    puts "5. Пошук за назвою"
    puts "6. Фільтр за категорією"
    puts "7. Фільтр за статусом"
    puts "8. Показати загальну суму витрат"
    puts "9. Зберегти у JSON"
    puts "0. Вихід"
    print "Оберіть дію: "
    
    choice = gets.chomp

    case choice
    when "1"
      print "Назва: "
      title = gets.chomp.strip
      if title.empty?
        puts "Назва не може бути порожньою!"
        next
      end

      print "Категорії (через кому): "
      categories = gets.chomp.split(",").map(&:strip)

      print "Способи оплати (через кому, напр. Картка, Готівка): "
      payment_methods = gets.chomp.split(",").map(&:strip)

      print "Сума: "
      amount = gets.chomp.to_f

      print "Дата (YYYY-MM-DD): "
      date = gets.chomp.strip

      print "Нотатки: "
      notes = gets.chomp.strip

      print "Статус (#{Expense::STATUSES.join(', ')}): "
      status = gets.chomp.strip.downcase

      expense = Expense.new(title, categories, payment_methods, amount, date, notes, status)
      manager.add(expense)

    when "2" 
      puts "\n--- СПИСОК ВИТРАТ ---"
      manager.show_all

    when "3" 
      print "Введіть ID запису для редагування: "
      id = gets.chomp.to_i
      manager.edit_expense(id)

    when "4"
      print "Введіть ID запису для видалення: "
      id = gets.chomp.to_i
      manager.delete(id)

    when "5" 
      print "Введіть частину назви: "
      text = gets.chomp
      puts "\n--- Результати пошуку ---"
      manager.find_by_title(text)

    when "6" 
      print "Введіть категорію: "
      category = gets.chomp
      puts "\n--- Результати фільтрації ---"
      manager.filter_by_category(category)

    when "7" 
      print "Введіть статус: "
      status = gets.chomp
      puts "\n--- Результати фільтрації ---"
      manager.filter_by_status(status)

    when "8" 
      manager.total_amount

    when "9" 
      manager.save_to_json("expenses.json")
      puts "Дані успішно збережено у expenses.json."

    when "0" 
      break

    else
      puts "Невірний вибір. Спробуйте ще раз."
    end
  end

ensure
  manager.save_to_yaml("expenses.yaml")
  puts "\nРоботу завершено. Дані автоматично збережено у expenses.yaml."
end