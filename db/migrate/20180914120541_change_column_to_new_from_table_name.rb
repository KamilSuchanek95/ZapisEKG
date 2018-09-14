class ChangeColumnToNewFromTableName < ActiveRecord::Migration[5.2]
  change_table :users do |t|
    t.change :pesel, :bigint
  end
end
