require 'rails_helper'

describe 'Usuário cadastra um modelo de produto' do 

    it 'com sucesso' do
        #Arrange 
        user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
        s_1 = Supplier.create!(brand_name: 'Samsung', corporate_name:'Samsung Eletronicos LTDA', registration_number: '4512784579', 
                               full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
        s_2 = Supplier.create!(brand_name: 'LG', corporate_name:'LG Eletronicos LTDA', registration_number: '2451845651', 
                               full_address: 'Av Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
        
        #Act
        login_as(user)
        visit root_path
        click_on "Modelos de Produto"
        click_on "Cadastrar Novo"
        fill_in 'Nome', with: 'TV 40 polegadas'
        fill_in 'Peso', with: 10_000
        fill_in 'Altura', with: 60
        fill_in 'Largura', with: 90
        fill_in 'Profundidade', with: 10
        fill_in 'SKU', with: 'TV40-SAMS-XPTO'
        select 'LG', from: 'Fornecedor'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content 'Modelo de produto cadastrado com sucesso'
        expect(page).to have_content 'TV 40 polegadas'
        expect(page).to have_content 'SKU: TV40-SAMS-XPTO'
        expect(page).to have_content 'Dimensões: 90cm x 60cm x 10cm'
        expect(page).to have_content 'Peso: 10000g'
        expect(page).to have_content 'Fornecedor: LG'

    end

    it 'e deve preencher todos os campos' do 
        #Arrange 
        user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
        s = Supplier.create!(brand_name: 'Samsung', corporate_name:'Samsung Eletronicos LTDA', registration_number: '4512784579', 
                               full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')

        #Act
        login_as(user)
        visit root_path
        click_on "Modelos de Produto"
        click_on "Cadastrar Novo"
        fill_in 'Nome', with: ''
        fill_in 'SKU', with: ''
        click_on 'Enviar'

        expect(page).to have_content 'Não foi possível cadastrar o produto.'
    end

end