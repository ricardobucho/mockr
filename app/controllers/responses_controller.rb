# frozen_string_literal: true

class ResponsesController < ApplicationController
  def show
    @response = Response.find(params[:id])

    render "_show"
  end
end
