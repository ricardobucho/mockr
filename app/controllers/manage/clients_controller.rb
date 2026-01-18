# frozen_string_literal: true

module Manage
  class ClientsController < BaseController
    before_action :set_client, only: %i[edit update destroy delete]

    def new
      @client = Client.new
      authorize! @client
    end

    def create
      @client = Client.new(client_params)
      authorize! @client

      if @client.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              render_toast("Client <strong>#{ERB::Util.html_escape(@client.name)}</strong> created successfully"),
              turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) }),
              close_drawer
            ]
          end
          format.html { redirect_to root_path, notice: "Client created successfully" }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize! @client
    end

    def update
      authorize! @client

      if @client.update(client_params)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              render_toast("Client <strong>#{ERB::Util.html_escape(@client.name)}</strong> updated successfully"),
              turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) })
            ]
          end
          format.html { redirect_to root_path, notice: "Client updated successfully" }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def delete
      authorize! @client, to: :destroy?
      render_delete_modal(@client, manage_client_path(@client))
    end

    def destroy
      authorize! @client
      client_name = @client.name
      @client.destroy

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            render_toast("Client <strong>#{ERB::Util.html_escape(client_name)}</strong> deleted successfully"),
            turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) }),
            close_modal,
            close_drawer
          ]
        end
        format.html { redirect_to root_path, notice: "Client deleted successfully" }
      end
    end

    private

    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:name, :slug, :description)
    end
  end
end
