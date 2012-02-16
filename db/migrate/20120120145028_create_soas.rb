class CreateSoas < ActiveRecord::Migration
  def change
    create_table :soas do |t|
      t.string :next_token

      t.timestamps
    end
  end
end
