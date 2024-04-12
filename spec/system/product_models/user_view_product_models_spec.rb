require 'rails_helper'

describe 'Usuário vê modelos de produto' do 
    it 'a partir do menu' do
        #Arrange

        #Act
        visit root_path
        within('nav') do
            click_on 'Modelos de Produto'
        end

        #Assert
        expect(current_path).to eq product_models_path

    end

    it 'com sucesso' do
      #Arrange
      s = Supplier.create!(brand_name: 'Samsung', corporate_name:'Samsung LTDA', registration_number: '4512784579', 
                              full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
      ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SAMSU-XPTO90', supplier: s)
      ProductModel.create!(name: 'Soundbar', weight: 3000, width: 80, height: 15, depth: 20, sku: 'SOUN-71-SU-NOISE', supplier: s)

      #Act
      visit root_path
        within('nav') do
            click_on 'Modelos de Produto'
        end

      #Assert
      expect(page).to have_content 'TV 32'
      expect(page).to have_content 'TV32-SAMSU-XPTO90'
      expect(page).to have_content 'Samsung'
      expect(page).to have_content 'Soundbar'
      expect(page).to have_content 'TV32-SAMSU-XPTO90'
      expect(page).to have_content 'Samsung'

    end

    it 'e não existem produtos cadastrados' do
      #Arrange

      #Act
      visit root_path
      click_on 'Modelos de Produto'

      #Assert
      expect(page).to have_content 'Nenhum modelo de produto cadastrado'

    end

end