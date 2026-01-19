# frozen_string_literal: true

module Manage
  class ClientsController < BaseController
    before_action :set_client, only: %i[edit update destroy delete]

    def new
      @client = Client.new
      authorize! @client
    end

    def edit
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
              refresh_clients_list,
              close_drawer,
            ]
          end
          format.html { redirect_to root_path, notice: t("flash.manage.clients.created") }
        end
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      authorize! @client

      if @client.update(client_params)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              render_toast("Client <strong>#{ERB::Util.html_escape(@client.name)}</strong> updated successfully"),
              refresh_clients_list,
            ]
          end
          format.html { redirect_to root_path, notice: t("flash.manage.clients.updated") }
        end
      else
        render :edit, status: :unprocessable_content
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
            refresh_clients_list,
            close_modal,
            close_drawer,
          ]
        end
        format.html { redirect_to root_path, notice: t("flash.manage.clients.deleted") }
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
