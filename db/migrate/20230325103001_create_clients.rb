class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :slug, null: false, unique: true
      t.text :description
      t.timestamps
      t.datetime :deleted_at, index: true
    end
  end
end
