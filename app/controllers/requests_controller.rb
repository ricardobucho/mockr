class RequestsController < ApplicationController
  def show
    @request = Request.find(params[:id])
    @logs = @request.logs.order(created_at: :desc).limit(25)

    render "_show"
  end
end
