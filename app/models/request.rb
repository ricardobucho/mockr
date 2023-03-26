class Request < ApplicationRecord
  acts_as_paranoid

  belongs_to :client
  has_many :responses, dependent: :destroy

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
end
