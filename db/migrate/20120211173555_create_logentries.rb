class CreateLogentries < ActiveRecord::Migration
  def change
    create_table :logentries do |t|
      t.references :logclass
      t.references :loggable, :polymorphic => true 
      t.timestamps
    end    
  end
end
