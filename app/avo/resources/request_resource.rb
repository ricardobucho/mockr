class RequestResource < Avo::BaseResource
  self.title = :name
  self.includes = []

  field :id, as: :id
  field :client, as: :belongs_to, required: true
  field :name, as: :text, required: true
  field :description, as: :text
  field :method, as: :select, enum: Request.methods, required: true
  field :path, as: :text, required: true
  field :responses, as: :has_many
end
