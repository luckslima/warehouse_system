#OPÇÃO MAIS LENTA PARA O PROCESSAMENTO DO CÓDIGO
def login(user)
        click_on 'Entrar'
        fill_in 'E-mail', with: user.email
        fill_in 'Senha', with: user.password
        within('form') do
          click_on 'Entrar'
        end
end