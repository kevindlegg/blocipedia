class ChangeAmountInAmounts < ActiveRecord::Migration[5.2]
  def change
    change_column :amounts, :amount, :decimal, precision: 5, scale: 2
  end
end
