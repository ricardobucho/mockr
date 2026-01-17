# frozen_string_literal: true

class Client < ApplicationRecord
  acts_as_paranoid

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  has_many :requests, -> { order(:name) }, dependent: :destroy
  has_many :indices, through: :requests
  has_many :responses, through: :requests
  has_many :logs, through: :requests
end
