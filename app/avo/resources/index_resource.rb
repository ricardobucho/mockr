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

  field(
    :template,
    as: :code,
    language: "json",
    default: nil,
    help:
      <<~HELP.squish,
        The JSON template is used to transform and render each response element.
        We leverage the <b>ERB</b> templating engine for ease of manipulation.
        The iterating response item is available as a variable named
        <code>response</code> and has been parsed into a symbolized Ruby hash.
      HELP
  )
end
