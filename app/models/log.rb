# frozen_string_literal: true

class Log < ApplicationRecord
  belongs_to :request

  validates :data, presence: true
end
