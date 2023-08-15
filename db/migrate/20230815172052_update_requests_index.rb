# frozen_string_literal: true

class UpdateRequestsIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :requests, %i[client_id path]
    add_index :requests, %i[client_id method path], unique: true
  end
end
