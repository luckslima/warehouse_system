class Warehouse < ApplicationRecord
    validates :name, :code, :city, :description, :address, :cep, :area, presence: true
end
