class AddHaulierCodeToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :haulier_code, :string
  end
end
