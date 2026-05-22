class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def index
    @expenses = Expense.all
  end

  def paid
    @expenses = Expense.paid_expenses 
    render :index
  end

  def this_month
    @expenses = Expense.this_month 
    render :index                  
  end

  def show
  end

  def new
    @expense = Expense.new
  end

  def edit
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      redirect_to @expense, notice: "Витрату успішно створено."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      redirect_to @expense, notice: "Витрату успішно оновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Витрату видалено.", status: :see_other
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:title, :category, :amount, :date, :notes, :payment_method, :status, :merchant)
  end
end