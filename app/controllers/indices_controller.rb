# frozen_string_literal: true

class IndicesController < ApplicationController
  def show
    render "_show", locals: { index: Index.find(params[:id]) }
  end
end
