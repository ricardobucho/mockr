# frozen_string_literal: true

class LogResource < Avo::BaseResource
  self.title = :created_at
  self.includes = []

  field :id, as: :id
  field :created_at, as: :date_time, readonly: true
  field :request, as: :belongs_to, readonly: true
  field :data, as: :code, readonly: true
end
