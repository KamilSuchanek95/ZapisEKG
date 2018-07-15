class CreatePrzebiegis < ActiveRecord::Migration[5.2]
  def change
    create_table :przebiegis do |t|
      t.decimal :zapis, array: true
      t.integer :user_id

      t.timestamps
    end
  end
end
