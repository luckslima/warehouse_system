require 'rails_helper'

describe 'Usuário cadastra o pedido' do 

    it 'e deve estar autenticado' do
        #Arrange

        #Act
        visit root_path
        click_on 'Registrar Pedido'

        #Assert
        expect(current_path).to eq new_user_session_path

    end

    it 'com sucesso' do
        #Arrange
        user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')
        other_warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CWB', city: 'Cuiaba', area: 10_000,
                                            address: 'Av dos Jacarés, 1000', cep: '56000-000', 
                                            description: 'Galpão no centro do país')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                         address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                         description: 'Galpão destinado a cargas internacionais')
        other_supplier = Supplier.create!(corporate_name:'Spark LTDA', brand_name: 'Spark', registration_number: '12545729', 
                                    full_address: 'Av etc, 3000', city: 'São Paulo', state: 'SP', email: 'contato@spark.com.br')
        supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                    full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')
        

        #ACT
        login_as(user)
        visit root_path
        click_on 'Registrar Pedido'
        select 'GRU - Aeroporto SP', from: 'Galpão destino'
        select supplier.corporate_name, from: 'Fornecedor'
        fill_in 'Data prevista de entrega', with: '20/12/2024'
        click_on 'Gravar'

        #Assert
        expect(page).to have_content 'Pedido registrado com sucesso.'
        expect(page).to have_content 'Galpão destino: GRU - Aeroporto SP'
        expect(page).to have_content 'Fornecedor: ACME LTDA'
        expect(page).to have_content 'Usuário responsável: Sérgio - sergio@email.com'
        expect(page).to have_content 'Data prevista de entrega: 20/12/2024'
        

    end

end