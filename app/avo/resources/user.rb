# frozen_string_literal: true

class Avo::Resources::User < Avo::BaseResource
  self.title = :email
  self.includes = []

  def fields
    field :id, as: :id
    field :provider, as: :text, readonly: true
    field :provider_uid, as: :text, readonly: true
    field :provider_username, as: :text, readonly: true
    field :provider_email, as: :text, readonly: true
    field :role, as: :select, enum: User.roles, required: true
  end
end
