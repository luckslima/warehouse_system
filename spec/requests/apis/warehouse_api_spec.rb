require 'rails_helper'

describe 'Warehouse API' do

    context 'GET api/v1/warehouses/1' do 

        it 'success' do
            #Arrange
            user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
            warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                          address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                                          description: 'Galpão destinado a cargas internacionais')
    
    
            #Act
            get "/api/v1/warehouses/#{warehouse.id}"
    
    
            #Assert
            expect(response.status).to eq 200
            expect(response.content_type).to include 'application/json'
            json_response = JSON.parse(response.body)
            expect(json_response["name"]).to eq('Aeroporto SP')
            expect(json_response["code"]).to eq('GRU')
            expect(json_response.keys).not_to include("created_at")
            expect(json_response.keys).not_to include("updated_at")

        end

        it 'fail if warehouse not found' do
            #Arrange
    
            #Act
            get "/api/v1/warehouses/999999999"
    
            #Act
            expect(response.status).to eq 404
    
        end

    end

    context 'GET api/v1/warehouses' do

        it 'list all warehouses sorted by name' do
            #Arrange
            Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                         address:'Av do porto, 1000' , cep:'20000-000', description:'Galpão do Rio')
            Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio', area: 50_000,
                         address:'Av Atlantica, 50' , cep:'80000-000', description:'Perto do Aeroporto')

            #Act
            get "/api/v1/warehouses"

            #Assert
            expect(response.status).to eq 200
            expect(response.content_type).to include 'application/json'
            json_response = JSON.parse(response.body)
            expect(json_response.length).to eq 2
            expect(json_response[0]['name']).to eq 'Maceio'
            expect(json_response[1]['name']).to eq 'Rio'

        end

        it 'return empty if there is no warehouse' do
            #Arrange

             #Act
             get "/api/v1/warehouses"

             #Assert
             expect(response.status).to eq 200
             expect(response.content_type).to include 'application/json'
             json_response = JSON.parse(response.body)
             expect(json_response.length).to eq 0

        end

        it 'and raise an internal error' do
            #Arrange
            allow(Warehouse).to receive(:all).and_raise(ActiveRecord::ActiveRecordError)

            #Act
            get "/api/v1/warehouses"


            #Assert
            expect(response).to have_http_status(500)


        end

    end

    context 'POST api/v1/warehouses' do 

        it 'success' do     
            #Arrange
            warehouse_params = {
                warehouse: {
                            name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                            address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                            description: 'Galpão destinado a cargas internacionais'
                           }
            }

            #Act
            post '/api/v1/warehouses', params: warehouse_params

            #Assert
            expect(response).to have_http_status(201)
            expect(response.content_type).to include 'application/json'
            json_response = JSON.parse(response.body)
            expect(json_response["name"]).to eq('Aeroporto SP')
            expect(json_response["code"]).to eq('GRU')
            expect(json_response["city"]).to eq('Guarulhos')
            expect(json_response["area"]).to eq(100_000)
            expect(json_response["address"]).to eq('Avenida do aeroporto, 1000')
            expect(json_response["cep"]).to eq('15000-000')
            expect(json_response["description"]).to eq('Galpão destinado a cargas internacionais')
            
        end

        it 'fail if paramaters are not complete' do
            #Arrange
            warehouse_params = {
                warehouse: {
                            name: 'Aeroporto SP', code: 'GRU'
                           }
            }

            #Act
            post '/api/v1/warehouses', params: warehouse_params

            #Assert
            expect(response).to have_http_status(406)
            expect(response.body).to include 'Descrição não pode ficar em branco'
            expect(response.body).to include 'Cidade não pode ficar em branco'


        end

        it 'fail if theres an internal error' do
            #Arrange
            allow(Warehouse).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)
            
            warehouse_params = {
                warehouse: {
                            name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                            address: 'Avenida do aeroporto, 1000', cep: '15000-000', 
                            description: 'Galpão destinado a cargas internacionais'
                           }
            }

            #Act
            post '/api/v1/warehouses', params: warehouse_params

            #Assert
            expect(response).to have_http_status(500)

        end

    end

end