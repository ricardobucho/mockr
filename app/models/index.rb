# frozen_string_literal: true

class Index < ApplicationRecord
  acts_as_paranoid

  belongs_to :request

  enum :method, Request.methods

  validates :name, presence: true
  validates :method, presence: true
  validates :path, presence: true

  before_save :prepend_slash_to_path!

  private

  def prepend_slash_to_path!
    return if path.blank? || path.start_with?("/")

    self.path = "/#{path}"
  end
end
