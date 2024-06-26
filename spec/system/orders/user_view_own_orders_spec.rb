require 'rails_helper'

describe 'Usuário vê seus próprios pedidos' do

    it 'e deve estar autenticado' do
    #Arrange

    #Act
    visit root_path

    #Assert
    expect(page).not_to have_content('Meus Pedidos')

    end

    it 'e não vê outros pedidos' do
        #Arrange
        user_1 = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')
        user_2 = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                      address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                      description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                      full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')                              

        order_1 = Order.create!(user:user_1, warehouse:warehouse, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now)
        order_2 = Order.create!(user:user_2, warehouse:warehouse, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now)
        order_3 = Order.create!(user:user_1, warehouse:warehouse, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now)

        #Act
        login_as(user_1)
        visit root_path
        click_on 'Meus Pedidos'

        #Assert
        expect(page).to have_content order_1.code
        expect(page).not_to have_content order_2.code
        expect(page).to have_content order_3.code

    end

    it 'e visita um pedido' do
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
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code


        #Assert
        expect(page).to have_content 'Detalhes do Pedido'
        expect(page).to have_content order.code
        expect(page).to have_content 'Galpão destino: GRU - Aeroporto SP'
        expect(page).to have_content 'Fornecedor: ACME LTDA'
        formatted_date = I18n.localize(1.day.from_now.to_date)
        expect(page).to have_content "Data prevista de entrega: #{formatted_date}"

    end

    it 'e não visita pedidos de outros usuários' do
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
        visit order_path(order.id)


        #Assert
        expect(current_path).not_to eq order_path(order.id)
        expect(current_path).to eq root_path
        expect(page).to have_content 'Você não possui acesso a esse pedido.'

    end

end