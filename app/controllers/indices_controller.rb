# frozen_string_literal: true

class IndicesController < ApplicationController
  def show
    @index = Index.find(params[:id])

    render "_show"
  end
end
