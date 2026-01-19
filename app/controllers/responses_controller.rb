# frozen_string_literal: true

class ResponsesController < ApplicationController
  def show
    render "_show", locals: { response: Response.find(params[:id]) }
  end
end
