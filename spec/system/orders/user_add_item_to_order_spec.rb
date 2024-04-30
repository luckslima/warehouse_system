require 'rails_helper'

describe 'Usuário adiciona itens ao pedido' do 

    it 'com sucesso' do 
        #Arrange
        user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                      address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                      description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                      full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')                             
        order = Order.create!(user:user, warehouse:warehouse, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now)

        product_1 = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SAMSU-XPTO90', supplier: supplier)
        product_2 = ProductModel.create!(name: 'Soundbar', weight: 3000, width: 80, height: 15, depth: 20, sku: 'SOUN-71-SU-NOISE', supplier: supplier)

        #Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        click_on 'Adicionar Item'
        select 'TV 32', from: 'Produto'
        fill_in 'Quantidade', with: "8"
        click_on 'Gravar'

        #Assert
        expect(current_path).to eq order_path(order.id)
        expect(page).to have_content 'Item adicionado com sucesso'
        expect(page).to have_content '8 x TV 32'

    end

    it 'e não vê produtos de outro fornecedor' do 
        #Arrange
        user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                      address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                      description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                      full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')
        other_supplier = Supplier.create!(corporate_name:'Spark LTDA', brand_name: 'Spark', registration_number: '12545729', 
                                    full_address: 'Av etc, 3000', city: 'São Paulo', state: 'SP', email: 'contato@spark.com.br')                              
        order = Order.create!(user:user, warehouse:warehouse, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now)
        product_1 = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SAMSU-XPTO90', supplier: supplier)
        product_2 = ProductModel.create!(name: 'Soundbar', weight: 3000, width: 80, height: 15, depth: 20, sku: 'SOUN-71-SU-NOISE', supplier: other_supplier)

        #Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        click_on 'Adicionar Item'

        #Assert
        expect(page).to have_content 'TV 32'
        expect(page).not_to have_content 'Soundbar'

    end

end