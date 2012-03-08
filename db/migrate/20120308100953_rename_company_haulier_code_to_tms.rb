class RenameCompanyHaulierCodeToTms < ActiveRecord::Migration
  def up
    rename_column :companies, :haulier_code, :tms
  end

  def down
    rename_column :companies, :tms, :haulier_code
  end
end
