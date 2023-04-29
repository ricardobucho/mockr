class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.belongs_to :request, null: false, foreign_key: true, index: true
      t.jsonb :data, default: {}, null: false
      t.timestamps
    end
  end
end
