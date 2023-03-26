class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.belongs_to :client, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.text :description
      t.string :method, null: false
      t.string :path, null: false
      t.timestamps
      t.datetime :deleted_at, index: true
    end

    add_index :requests, %i[client_id path], unique: true
  end
end
