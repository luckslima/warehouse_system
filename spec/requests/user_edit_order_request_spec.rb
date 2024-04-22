require 'rails_helper'

describe 'Usuário edita um pedido' do

    it 'e não é o dono' do
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
        patch(order_path(order.id), params: {order: { supplier_id: 1 }})

        #Assert
        expect(response).to redirect_to(root_path)        


    end

end