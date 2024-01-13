# frozen_string_literal: true

class Avo::Resources::Client < Avo::BaseResource
  self.title = :name
  self.includes = %i[requests responses logs]

  def fields
    field :requests, as: :has_many

    field :id, as: :id
    field :name, as: :text, required: true
    field :slug, as: :text, required: true
  end
end
