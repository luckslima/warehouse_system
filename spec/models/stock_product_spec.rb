require 'rails_helper'

RSpec.describe StockProduct, type: :model do

    describe 'gera um  número de série' do

        it 'ao criar um StockProduct' do 
            #Arrange
            user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')
            warehouse = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                        address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                        description: 'Galpão destinado a cargas internacionais')

            supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                        full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')

            product = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SAMSU-XPTO90', supplier: supplier)

            order = Order.create!(user: user, warehouse:warehouse, supplier:supplier, 
                                estimated_delivery_date: 1.month.from_now) 

            #Act
            stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)

            #Assert
            expect(stock_product.serial_number.length).to eq 20

        end

        it 'e não é modificado' do 
            #Arrange
            user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')
            warehouse = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                        address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                        description: 'Galpão destinado a cargas internacionais')
            other_warehouse = Warehouse.create(name: 'Aeroporto Salvador', code: 'SSA', city: 'Salvador', area: 100_000,
                                        address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                        description: 'Galpão destinado a cargas internacionais')
            supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                        full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')

            product = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SAMSU-XPTO90', supplier: supplier)

            order = Order.create!(user: user, warehouse:warehouse, supplier:supplier, 
                                estimated_delivery_date: 1.month.from_now) 
            stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)

            original_serial_number = stock_product.serial_number

            #Act
            stock_product.update(warehouse: other_warehouse)

            #Assert
            expect(stock_product.serial_number).to eq original_serial_number
            
        end

    end

end
