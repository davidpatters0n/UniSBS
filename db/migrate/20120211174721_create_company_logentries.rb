class CreateCompanyLogentries < ActiveRecord::Migration
  def change
    create_table :company_logentries do |t|
      t.string   "name"
      t.string   "haulier_code"
    end    
  end
end
