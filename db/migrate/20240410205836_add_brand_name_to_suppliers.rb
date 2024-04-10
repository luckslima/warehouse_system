class AddBrandNameToSuppliers < ActiveRecord::Migration[7.1]
  def change
    add_column :suppliers, :brand_name, :string
  end
end
