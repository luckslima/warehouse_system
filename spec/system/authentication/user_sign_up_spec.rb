require 'rails_helper'

describe 'Usuário se cadastra' do
    it 'com sucesso' do
        #Arrange

        #Act
        visit root_path
        click_on 'Entrar'
        click_on 'Criar uma conta'
        fill_in 'Nome', with: 'Maria'
        fill_in 'E-mail', with: 'maria@email.com'
        fill_in 'Senha', with: 'maria123'
        fill_in 'Confirme sua senha', with: 'maria123'
        click_on 'Criar conta'

        #Assert
        expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
        expect(page).to have_content 'Maria'
        expect(page).to have_button 'Sair'

    end


end