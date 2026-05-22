class PaymentMethodsController < ApplicationController
    def create
      @payment_method = PaymentMethod.new(payment_method_params)
      if @payment_method.save
        redirect_to expense_path(@payment_method.expense_id), notice: "Спосіб оплати додано!"
      else
        redirect_back fallback_location: root_path, alert: "Помилка додавання."
      end
    end
  
    def destroy
      @payment_method = PaymentMethod.find(params[:id])
      expense_id = @payment_method.expense_id
      @payment_method.destroy
      redirect_to expense_path(expense_id), notice: "Спосіб оплати видалено."
    end
  
    private
  
    def payment_method_params
      params.require(:payment_method).permit(:name, :expense_id)
    end
  end