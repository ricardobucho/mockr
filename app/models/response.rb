# frozen_string_literal: true

class Response < ApplicationRecord
  acts_as_paranoid

  attribute :body, :string

  belongs_to :request

  enum format: {
    "JSON" => "json",
    "HTML" => "html",
    "XML" => "xml",
  }

  validates :format, presence: true
  validates :status, presence: true
  validates :name, presence: true, uniqueness: { scope: :request_id }

  before_save :set_path!
  before_save :upload_response!

  def body
    return attributes["body"] if path.blank? || new_record?

    @body ||= AwsS3Manager.instance.get(path).body.read
  end

  private

  def set_path!
    return if path.present?

    self.path = "mockr/responses/#{SecureRandom.uuid}"
  end

  def upload_response!
    AwsS3Manager.instance.put(path, attributes["body"])
  end
end
