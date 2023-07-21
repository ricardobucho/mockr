# frozen_string_literal: true

class AwsS3Manager
  include Singleton

  def get(key)
    resource.bucket(bucket_name).object(key).get
  end

  def put(key, body)
    resource.bucket(bucket_name).object(key).put(
      body:,
      server_side_encryption: "AES256",
    )
  end

  private

  def resource = @resource = Aws::S3::Resource.new(client:)
  def bucket_name = ENV.fetch("AWS_S3_BUCKET", nil)

  def client
    @client ||= Aws::S3::Client.new(
      region: ENV.fetch("AWS_REGION", nil),
      access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID", nil),
      secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY", nil),
      **role_credentials,
    )
  end

  def role_credentials
    return {} if ENV.fetch("AWS_ROLE_ARN", nil).blank?

    {
      credentials: Aws::AssumeRoleCredentials.new(
        client: Aws::STS::Client.new,
        role_arn: ENV.fetch("AWS_ROLE_ARN", nil),
        role_session_name: ENV.fetch("AWS_ROLE_SESSION_NAME", nil),
      ),
    }
  end
end
