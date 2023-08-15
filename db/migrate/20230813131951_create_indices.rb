# frozen_string_literal: true

class CreateIndices < ActiveRecord::Migration[7.0]
  def change
    create_table :indices do |t|
      t.belongs_to :request, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.text :description
      t.string :method, null: false
      t.string :path, null: false
      t.integer :status, null: false, default: 200
      t.integer :throttle, default: 0
      t.jsonb :headers, default: {}, null: false
      t.jsonb :properties, default: {}, null: false
      t.timestamps
      t.datetime :deleted_at, index: true
    end

    add_index :indices, %i[request_id method path], unique: true
  end
end
