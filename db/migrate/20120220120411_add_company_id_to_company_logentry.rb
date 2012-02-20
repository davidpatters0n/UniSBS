class AddCompanyIdToCompanyLogentry < ActiveRecord::Migration
  def change
    add_column :company_logentries, :company_id, :integer
  end
end
