require 'rails_helper'

describe 'Usuário atualiza o status do pedido' do 

    it 'para um pedido que foi entregue' do
        #Arrange
        user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                      address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                      description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                      full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')
        product = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SAMSU-XPTO90', supplier: supplier)
        order = Order.create!(user:user, warehouse:warehouse, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now, status: :pending)

        OrderItem.create!(order: order, product_model: product, quantity: 5)

        #Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        click_on 'Marcar como ENTREGUE'

        #Assert
        expect(current_path).to eq order_path(order.id)
        expect(page).to have_content("Situação do pedido: Entregue")
        expect(page).not_to have_button "Marcar como CANCELADO"
        expect(page).not_to have_button "Marcar como ENTREGUE"
        expect(StockProduct.count).to eq 5
        expect(StockProduct.where(warehouse:warehouse, product_model: product).count).to eq 5
    end

    it 'para um pedido que foi cancelado' do
            #Arrange
        user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                      address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                      description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                      full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')
        product = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SAMSU-XPTO90', supplier: supplier)
        order = Order.create!(user:user, warehouse:warehouse, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now, status: :pending)
        OrderItem.create!(order: order, product_model: product, quantity: 5)

        #Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        click_on 'Marcar como CANCELADO'

        #Assert
        expect(current_path).to eq order_path(order.id)
        expect(page).to have_content("Situação do pedido: Cancelado")
        expect(StockProduct.count).to eq 0

    end

end