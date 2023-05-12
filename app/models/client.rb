# frozen_string_literal: true

class Client < ApplicationRecord
  acts_as_paranoid

  has_many :requests, dependent: :destroy
  has_many :responses, through: :requests
end
