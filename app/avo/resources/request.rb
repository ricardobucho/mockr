# frozen_string_literal: true

class Avo::Resources::Request < Avo::BaseResource
  self.title = :name
  self.includes = %i[indices responses logs]

  def fields
    field :id, as: :id
    field :client, as: :belongs_to, required: true
    field :name, as: :text, required: true
    field :description, as: :text
    field :method, as: :select, enum: Request.methods, required: true
    field :path, as: :text, required: true

    field :indices, as: :has_many
    field :responses, as: :has_many
    field :logs, as: :has_many
  end
end
