class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order_and_check_user, only: [:show, :edit, :update, :delivered, :canceled]

    def index
        @orders = current_user.orders
    end

    def new
        @order = Order.new
        @warehouses = Warehouse.all
        @suppliers = Supplier.all 
    end

    def create
        order_params = params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date)
        @order = Order.new(order_params)
        @order.user = current_user
        @order.save!
        redirect_to @order, notice: 'Pedido registrado com sucesso.'
    end

    def show

    end

    def search
        @code = params["query"]
        @orders = Order.where("code LIKE ?", "%#{@code}%")
    end

    def edit
        @warehouses = Warehouse.all
        @suppliers = Supplier.all 
    end

    def update

        order_params = params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date) 

        if @order.update(order_params)
            redirect_to @order, notice: 'Pedido atualizado com sucesso.'           
        else
            flash.now[:notice] = 'Não foi possível atualizar o pedido.'
            render 'edit'
        end
    end

    def delivered
        @order.delivered!
        @order.order_items.each do |i|
            i.quantity.times do
                StockProduct.create!(order: @order, product_model: i.product_model, warehouse: @order.warehouse)
            end

        end
        redirect_to @order
    end

    def canceled
        @order.canceled!
        redirect_to @order
    end

    private

    def set_order_and_check_user
        @order = Order.find(params[:id])

        if @order.user != current_user
            return redirect_to root_path, alert: 'Você não possui acesso a esse pedido.'
        end

    end
end