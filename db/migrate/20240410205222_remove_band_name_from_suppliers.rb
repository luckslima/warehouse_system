class RemoveBandNameFromSuppliers < ActiveRecord::Migration[7.1]
  def change
    remove_column :suppliers, :band_name, :string
  end
end
