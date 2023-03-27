class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      # User-related Attributes
      t.string :token, null: false, unique: true, index: true
      t.string :role, default: "user", null: false

      # Provider-related Attributes
      t.string :provider, null: false
      t.string :provider_uid, null: false
      t.string :provider_username, null: false
      t.string :provider_email, null: false
      t.string :oauth_token
      t.datetime :oauth_expires_at

      # Timestamps
      t.timestamps
      t.datetime :deleted_at, index: true
    end

    add_index :users, %i[provider_uid provider], unique: true
    add_index :users, %i[provider_email provider], unique: true
  end
end
