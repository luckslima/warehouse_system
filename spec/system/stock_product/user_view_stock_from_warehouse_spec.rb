require 'rails_helper'

describe 'Usuário vê o estoque' do
    it 'na tela do galpão' do
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
        product_3 = ProductModel.create!(name: 'Notebook', weight: 3000, width: 80, height: 20, depth: 25, sku: 'NOTEB-81-SU-NOISE', supplier: supplier)

        3.times { StockProduct.create!(order: order, warehouse: warehouse, product_model: product_1) }
        2.times { StockProduct.create!(order: order, warehouse: warehouse, product_model: product_2) }

        #Act
        login_as(user)
        visit root_path
        click_on 'Aeroporto SP'

        #Assert
        expect(page).to have_content 'Itens em Estoque'
        expect(page).to have_content '3 x TV32-SAMSU-XPTO90'
        expect(page).to have_content '2 x SOUN-71-SU-NOISE'
        expect(page).not_to have_content 'NOTEB-81-SU-NOISE'


    end
end