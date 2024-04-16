require 'rails_helper'

RSpec.describe Order, type: :model do

  describe '#valid?' do

    it 'deve ter um código' do 
      #Arrange
      user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')
      warehouse = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                  description: 'Galpão destinado a cargas internacionais')

      supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                  full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')

      order = Order.new(user: user, warehouse:warehouse, supplier:supplier, 
                        estimated_delivery_date: 1.month.from_now) 

      #Act
      result = order.valid?

      #Assert
      expect(result).to be true

    end

    it 'data estimada de entrega deve ser obrigatória' do
      #Arrange
      order = Order.new(estimated_delivery_date:'')

      #Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      #Assert
      expect(result).to be true
      expect(order.errors[:estimated_delivery_date]).to include("não pode ficar em branco")

    end

    it 'data estimada de entrega não deve ser antiga' do
      #Arrange
      order = Order.new(estimated_delivery_date: 1.day.ago)

      #Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      #Assert
      expect(result).to be true
      expect(order.errors[:estimated_delivery_date]).to include("deve ser no futuro!")

    end

    it 'data estimada de entrega não deve ser igual a hoje' do
      #Arrange
      order = Order.new(estimated_delivery_date: Date.today)

      #Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      #Assert
      expect(result).to be true
      expect(order.errors[:estimated_delivery_date]).to include("deve ser no futuro!")

    end

    it 'data estimada de entrega não deve ser igual a hoje' do
      #Arrange
      order = Order.new(estimated_delivery_date: 1.day.from_now)

      #Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      #Assert
      expect(result).to be false
  
    end

  end

  describe 'gera um código aleatório' do

    it 'ao criar um novo pedido' do
      #Arrange
      user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')
      warehouse = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                   address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                   description: 'Galpão destinado a cargas internacionais')

      supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                  full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')

      order = Order.new(user: user, warehouse:warehouse, supplier:supplier, 
                        estimated_delivery_date: 1.month.from_now) 

      #Act
      order.save!
      result = order.code
                                      
      #Assert
      expect(result).not_to be_empty
      expect(result.length).to eq 8

    end

    it 'e o código é único' do
      #Arrange
      user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'sergio123')
      warehouse = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                   address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                   description: 'Galpão destinado a cargas internacionais')

      supplier = Supplier.create!(corporate_name:'ACME LTDA', brand_name: 'ACME', registration_number: '12547869', 
                                  full_address: 'Av blah blah, 1000', city: 'Salvador', state: 'BA', email: 'contato@acme.com.br')

      order_1 = Order.create!(user: user, warehouse:warehouse, supplier:supplier, 
                        estimated_delivery_date: 1.month.from_now) 
      order_2 = Order.new(user: user, warehouse:warehouse, supplier:supplier, 
                        estimated_delivery_date: 1.month.from_now) 

      #Act
      order_2.save!
      result = order_2.code
                                      
      #Assert
      expect(result).not_to eq order_1.code
      
    end

  end
  
end
