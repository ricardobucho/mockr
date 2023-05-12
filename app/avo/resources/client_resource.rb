# frozen_string_literal: true

class ClientResource < Avo::BaseResource
  self.title = :name
  self.includes = %i[requests]

  field :requests, as: :has_many

  field :id, as: :id
  field :name, as: :text, required: true
  field :slug, as: :text, required: true
end
