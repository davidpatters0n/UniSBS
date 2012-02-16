class CreateLogclasses < ActiveRecord::Migration
  def change
    create_table :logclasses do |t|
      t.string :name
      t.timestamps
    end    
  end
end
