class RenameCompanyLogentryHaulierCodeToTms < ActiveRecord::Migration
  def up
    rename_column :company_logentries, :haulier_code, :tms
  end

  def down
    rename_column :company_logentries, :tms, :haulier_code
  end
end
