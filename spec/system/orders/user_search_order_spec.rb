require 'rails_helper'

describe 'Usuário busca por um pedido' do

    it 'a partir do menu' do 
        #Arrange
        user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')

        #Act
        login_as(user)
        visit root_path


        #Assert
        within('header nav') do
            expect(page).to have_field('Buscar Pedido')
            expect(page).to have_button('Buscar')
        end

    end

    it ' e deve estar autenticado' do
        #Arrange

        #Act
        visit root_path

        #Assert
        within('header nav') do
            expect(page).not_to have_field('Buscar Pedido')
            expect(page).not_to have_button('Buscar')
        end

    end

    it 'e encontra o pedido' do 
        #Arrange
        user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')
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
        fill_in 'Buscar Pedido', with: order.code
        click_on 'Buscar'


        #Assert
        expect(page).to have_content "Resultados da busca por: #{order.code}"
        expect(page).to have_content '1 pedido encontrado'
        expect(page).to have_content "Código: #{order.code}"
        expect(page).to have_content "Galpão destino: GRU - Aeroporto SP"
        expect(page).to have_content "Fornecedor: ACME LTDA"

    end

    it 'e encontra múltiplos pedidos' do 
        #Arrange
        user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')
        warehouse_1 = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                      address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                      description: 'Galpão destinado a cargas internacionais')
        warehouse_2 = Warehouse.create!(name: 'Aeroporto Rio', code: 'SDU', city: 'Rio de Janeiro', area: 100_000,
                                      address: 'Avenida do porto, 80', cep: '25000-000', 
                                      description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                    full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')
        allow(SecureRandom).to receive(:alphanumeric).and_return('GRU12345')
        order_1 = Order.create!(user:user, warehouse:warehouse_1, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now)
        allow(SecureRandom).to receive(:alphanumeric).and_return('GRU98765')
        order_2 = Order.create!(user:user, warehouse:warehouse_1, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now)
        allow(SecureRandom).to receive(:alphanumeric).and_return('SDU00000')
        order_3 = Order.create!(user:user, warehouse:warehouse_2, supplier:supplier,
                              estimated_delivery_date: 1.day.from_now)

        #Act
        login_as(user)
        visit root_path
        fill_in 'Buscar Pedido', with: 'GRU'
        click_on 'Buscar'


        #Assert
        expect(page).to have_content '2 pedidos encontrados'
        expect(page).to have_content "GRU12345"
        expect(page).to have_content 'GRU98765'
        expect(page).to have_content "Galpão destino: GRU - Aeroporto SP"
        expect(page).not_to have_content 'SDU00000'
        expect(page).not_to have_content "Galpão destino: SDU - Aeroporto Rio"

    end

end