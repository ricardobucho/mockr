class CreateResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :responses do |t|
      t.belongs_to :request, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.text :description
      t.jsonb :conditions, default: {}, null: false
      t.integer :status, null: false, default: 200
      t.jsonb :headers, default: {}, null: false
      t.string :path, null: false
      t.timestamps
      t.datetime :deleted_at, index: true
    end

    add_index :responses, %i[request_id name], unique: true
  end
end
