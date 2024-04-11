require 'rails_helper'

RSpec.describe ProductModel, type: :model do
    describe "#valid?" do
    it 'name is mandatory' do
        #Arrange
        s = Supplier.create!(brand_name: 'Samsung', corporate_name:'Samsung LTDA', registration_number: '4512784579', 
                             full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
        pm= ProductModel.new(name: '', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SAMSU-XPTO90', supplier: s)

        #Act
        result = pm.valid?

        #Assert
        expect(result).to eq false

    end

    it 'name is mandatory' do
        #Arrange
        s = Supplier.create!(brand_name: 'Samsung', corporate_name:'Samsung LTDA', registration_number: '4512784579', 
                             full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
        pm= ProductModel.new(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, sku: '', supplier: s)

        #Act
        result = pm.valid?

        #Assert
        expect(result).to eq false

    end

  end
end
