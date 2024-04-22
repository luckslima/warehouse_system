require 'rails_helper'

describe 'Usuário edita um pedido' do

    it 'e deve estar autenticado' do
        #Arrange
        user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
        other_user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                      address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                      description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                      full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')                              

        order = Order.create!(user:user, warehouse:warehouse, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now)

        #Act
        login_as(other_user)
        visit edit_order_path(order.id )

        #Assert
        expect(current_path).to eq root_path

    end

    it 'com sucesso' do
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

        #Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        click_on 'Editar'
        fill_in 'Data prevista de entrega', with: '12/12/2028'
        select 'Spark LTDA', from: 'Fornecedor'
        click_on 'Gravar'

        #Assert
        expect(page).to have_content 'Pedido atualizado com sucesso.'
        expect(page).to have_content 'Galpão destino: GRU - Aeroporto SP'
        expect(page).to have_content 'Fornecedor: Spark LTDA'
        expect(page).to have_content 'Data prevista de entrega: 12/12/2028'
        

    end

    it 'caso seja o responsável' do
        #Arrange
        user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                      address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                      description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                      full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')                              

        order = Order.create!(user:user, warehouse:warehouse, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now)

        #Act
        visit edit_order_path(order.id)

        #Assert
        expect(current_path).to eq new_user_session_path

    end

end