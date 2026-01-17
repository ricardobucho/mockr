# frozen_string_literal: true

module Manage
  class ResponsesController < BaseController
    before_action :set_response, only: %i[edit update destroy delete]
    before_action :set_request, only: %i[new create]

    def new
      @response = @request.responses.new(status: 200, format: "json")
      authorize! @response
    end

    def create
      @response = @request.responses.new(response_params)
      authorize! @response

      if @response.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              render_toast("Response '#{@response.name}' created successfully"),
              turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) }),
              close_stacked_drawer
            ]
          end
          format.html { redirect_to root_path, notice: "Response created successfully" }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize! @response
      @request = @response.request
    end

    def update
      authorize! @response

      if @response.update(response_params)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              render_toast("Response '#{@response.name}' updated successfully"),
              turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) })
            ]
          end
          format.html { redirect_to root_path, notice: "Response updated successfully" }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def delete
      authorize! @response, to: :destroy?
      render_delete_modal(@response, manage_response_path(@response))
    end

    def destroy
      authorize! @response
      response_name = @response.name
      @response.destroy

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            render_toast("Response '#{response_name}' deleted successfully"),
            turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) }),
            close_modal,
            close_stacked_drawer,
            close_drawer
          ]
        end
        format.html { redirect_to root_path, notice: "Response deleted successfully" }
      end
    end

    private

    def set_response
      @response = Response.find(params[:id])
    end

    def set_request
      @request = Request.find(params[:request_id])
    end

    def response_params
      permitted = params.require(:response).permit(:name, :description, :status, :format, :throttle, :body, :conditions, :headers)
      
      # Parse JSON strings for JSONB fields
      %i[conditions headers].each do |field|
        if permitted[field].is_a?(String)
          permitted[field] = JSON.parse(permitted[field]) rescue {}
        end
      end
      
      permitted
    end
  end
end
