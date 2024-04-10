require 'rails_helper'

describe 'Usuário remove um galpão' do 

    it 'com sucesso' do
        #Arrange
        w = Warehouse.create!(name: 'Cuiaba', code: 'CWB', city: 'Cuiaba', area: 10_000,
                                     address: 'Av dos Jacarés, 1000', cep: '56000-000', 
                                     description: 'Galpão no centro do país')

        #Act
        visit root_path
        click_on 'Cuiaba'
        click_on 'Remover'

        #Assert
        expect(current_path).to eq root_path
        expect(page).to have_content 'Galpão removido com sucesso'
        expect(page).not_to have_content 'Cuiaba'
        expect(page).not_to have_content 'CWB'

    end

    it 'e não apaga outros galpões' do
      #Arrange
      w_1 = Warehouse.create!(name: 'Cuiaba', code: 'CWB', city: 'Cuiaba', area: 10_000,
      address: 'Av dos Jacarés, 1000', cep: '56000-000', 
      description: 'Galpão no centro do país')
      w_2 = Warehouse.create!(name: 'Belo Horizonte', code: 'BHZ', city: 'Belo Horizonte', area: 20_000,
      address: 'Av Tiradentes, 20', cep: '46000-000', 
      description: 'Galpão para cargas mineiras')

      #Act
      visit root_path
      click_on 'Cuiaba'
      click_on 'Remover'

      #Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Galpão removido com sucesso'
      expect(page).not_to have_content 'Cuiaba'
      expect(page).not_to have_content 'CWB'
      expect(page).to have_content 'Belo Horizonte'
      expect(page).to have_content 'BHZ'

    end
end