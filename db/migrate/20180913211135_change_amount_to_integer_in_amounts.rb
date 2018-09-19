class ChangeAmountToIntegerInAmounts < ActiveRecord::Migration[5.2]
  def change
    change_column :amounts, :amount, :integer
  end
end
