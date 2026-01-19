# frozen_string_literal: true

module Manage
  class ResponsesController < BaseController
    before_action :set_response, only: %i[edit update destroy delete]
    before_action :set_request, only: %i[new create]

    def new
      @response = @request.responses.new(status: 200, format: "json")
      authorize! @response
    end

    def edit
      authorize! @response
      @request = @response.request
    end

    def create
      @response = @request.responses.new(response_params)
      authorize! @response

      if @response.save
        respond_to do |format|
          format.turbo_stream do
            streams = [
              render_toast("Response <strong>#{ERB::Util.html_escape(@response.name)}</strong> created successfully"),
              refresh_clients_list,
              close_stacked_drawer,
            ]
            streams << refresh_parent_drawer(@request) if from_stacked_drawer?
            render turbo_stream: streams
          end
          format.html { redirect_to root_path, notice: t("flash.manage.responses.created") }
        end
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      authorize! @response
      @request = @response.request

      if @response.update(response_params)
        respond_to do |format|
          format.turbo_stream do
            streams = [
              render_toast("Response <strong>#{ERB::Util.html_escape(@response.name)}</strong> updated successfully"),
              refresh_clients_list,
            ]
            streams << refresh_parent_drawer(@request) if from_stacked_drawer?
            render turbo_stream: streams
          end
          format.html { redirect_to root_path, notice: t("flash.manage.responses.updated") }
        end
      else
        render :edit, status: :unprocessable_content
      end
    end

    def delete
      authorize! @response, to: :destroy?
      render_delete_modal(@response, manage_response_path(@response))
    end

    def destroy
      authorize! @response
      response_name = @response.name
      @request = @response.request
      @response.destroy

      respond_to do |format|
        format.turbo_stream do
          streams = [
            render_toast("Response <strong>#{ERB::Util.html_escape(response_name)}</strong> deleted successfully"),
            refresh_clients_list,
            close_modal,
            close_stacked_drawer,
          ]
          streams << refresh_parent_drawer(@request) if from_stacked_drawer?
          render turbo_stream: streams
        end
        format.html { redirect_to root_path, notice: t("flash.manage.responses.deleted") }
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
      permitted = params.require(:response).permit(:name, :description, :status, :format, :throttle, :body,
                                                   :conditions, :headers)

      # Parse JSON strings for JSONB fields
      %i[conditions headers].each do |field|
        if permitted[field].is_a?(String)
          permitted[field] = begin
            JSON.parse(permitted[field])
          rescue StandardError
            {}
          end
        end
      end

      permitted
    end
  end
end
