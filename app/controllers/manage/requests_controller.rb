# frozen_string_literal: true

module Manage
  class RequestsController < BaseController
    before_action :set_request, only: %i[edit update destroy delete]
    before_action :set_client, only: %i[new create]

    def new
      @request = @client.requests.new(method: "GET")
      authorize! @request
    end

    def create
      @request = @client.requests.new(request_params)
      authorize! @request

      if @request.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              render_toast("Request <strong>#{ERB::Util.html_escape(@request.name)}</strong> created successfully"),
              turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) }),
              close_drawer
            ]
          end
          format.html { redirect_to root_path, notice: "Request created successfully" }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize! @request
      @client = @request.client
    end

    def update
      authorize! @request

      if @request.update(request_params)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              render_toast("Request <strong>#{ERB::Util.html_escape(@request.name)}</strong> updated successfully"),
              turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) })
            ]
          end
          format.html { redirect_to root_path, notice: "Request updated successfully" }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def delete
      authorize! @request, to: :destroy?
      render_delete_modal(@request, manage_request_path(@request))
    end

    def destroy
      authorize! @request
      request_name = @request.name
      @request.destroy

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            render_toast("Request <strong>#{ERB::Util.html_escape(request_name)}</strong> deleted successfully"),
            turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) }),
            close_modal,
            close_drawer
          ]
        end
        format.html { redirect_to root_path, notice: "Request deleted successfully" }
      end
    end

    private

    def set_request
      @request = Request.find(params[:id])
    end

    def set_client
      @client = Client.find(params[:client_id])
    end

    def request_params
      params.require(:request).permit(:name, :description, :method, :path)
    end
  end
end
