class ClientResource < Avo::BaseResource
  self.title = :name
  self.includes = []

  field :id, as: :id
  field :name, as: :text, required: true
  field :slug, as: :text, required: true
end
