require 'rails_helper' 

describe 'Usuário vê fornecedores' do

    it 'a partir do menu' do
        #Arrange

        #Act
        visit root_path
        click_on 'Fornecedores'

        #Assert
        expect(current_path).to eq suppliers_path
    end
    
end