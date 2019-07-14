class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :amount
      t.integer :sale, default: 0

      t.timestamps
    end
  end
end
