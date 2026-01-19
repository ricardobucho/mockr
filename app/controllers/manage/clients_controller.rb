# frozen_string_literal: true

module Manage
  class ClientsController < BaseController
    before_action :set_client, only: %i[edit update destroy delete]

    def index
      @clients = Client.includes(requests: %i[indices responses]).order(:name)
      authorize! Client
    end

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
            streams = [
              render_toast(resource_type: "Client", resource_name: @client.name, action: :created),
              refresh_clients_list,
            ]
            if from_stacked_drawer?
              streams << refresh_clients_drawer
              streams << close_stacked_drawer
            else
              streams << close_drawer
            end
            render turbo_stream: streams
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
            streams = [
              render_toast(resource_type: "Client", resource_name: @client.name, action: :updated),
              refresh_clients_list,
            ]
            streams << refresh_clients_drawer if from_stacked_drawer?
            streams << close_stacked_drawer if from_stacked_drawer?
            render turbo_stream: streams
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
          streams = [
            render_toast(resource_type: "Client", resource_name: client_name, action: :deleted),
            refresh_clients_list,
            close_modal,
          ]
          if from_stacked_drawer?
            streams << refresh_clients_drawer
            streams << close_stacked_drawer
          else
            streams << close_drawer
          end
          render turbo_stream: streams
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
