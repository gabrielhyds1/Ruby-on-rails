namespace :dev do

  DEFAULT_PASSWORD = "123456"

  desc 'Configura o ambiente de desenvolvimento'
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Apagando DB...') do
        `rails db:drop`
      end

      show_spinner('Criando DB...') do
        `rails db:create`
      end

      show_spinner('Migrando DB...') do
        `rails db:migrate`
      end

      show_spinner('Cadastrando o administrador padrão...') do
        `rails dev:add_default_admin`
      end

      show_spinner('Cadastrando o usuário padrão...') do
        `rails dev:add_default_user`
      end
    else
      puts 'A task só pode ser executada no ambiente de desenvolvimento'
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
  Admin.create!(
    email: 'admin@admin.com',
    password: DEFAULT_PASSWORD,
    password_confirmation: DEFAULT_PASSWORD
  )
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
  User.create!(
    email: "admin@example.com",
    password: "123456",
    password_confirmation: "123456"
  )
  end

  private

  def show_spinner(msg_start, msg_end = 'Concluído!')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
