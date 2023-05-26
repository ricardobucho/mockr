# frozen_string_literal: true

class AddThrottleToResponses < ActiveRecord::Migration[7.0]
  def change
    add_column :responses, :throttle, :integer, default: 0
  end
end
