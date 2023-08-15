# frozen_string_literal: true

class IndexResource < Avo::BaseResource
  self.title = :name
  self.includes = []

  field :id, as: :id
  field :request, as: :belongs_to, required: true
  field :name, as: :text, required: true
  field :description, as: :text
  field :method, as: :select, enum: Request.methods, required: true
  field :path, as: :text, required: true
  field :throttle, as: :number, default: 0, help: "The number of milliseconds to delay the request."
  field :status, as: :number, required: true
  field :headers, as: :key_value, default: {}
  field :properties, as: :key_value, default: {}
end
