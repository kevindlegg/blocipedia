class DropAmountsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :amounts do |t|
      t.integer "amount"
      t.boolean "default"
      t.timestamps
    end
  end
end
