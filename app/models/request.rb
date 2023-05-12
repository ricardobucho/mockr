# frozen_string_literal: true

class Request < ApplicationRecord
  acts_as_paranoid

  belongs_to :client
  has_many :responses, dependent: :destroy
  has_many :logs, dependent: :destroy

  enum method: {
    "GET" => "get",
    "POST" => "post",
    "PUT" => "put",
    "PATCH" => "patch",
    "DELETE" => "delete",
  }

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
