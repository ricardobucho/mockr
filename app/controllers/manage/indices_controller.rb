# frozen_string_literal: true

module Manage
  class IndicesController < BaseController
    before_action :set_index, only: %i[edit update destroy delete]
    before_action :set_request, only: %i[new create]

    def new
      @index = @request.indices.new(status: 200, method: "GET", template: "<%= response.to_json %>")
      authorize! @index
    end

    def edit
      authorize! @index
      @request = @index.request
    end

    def create
      @index = @request.indices.new(index_params)
      authorize! @index

      if @index.save
        respond_to do |format|
          format.turbo_stream do
            streams = [
              render_toast("Index <strong>#{ERB::Util.html_escape(@index.name)}</strong> created successfully"),
              refresh_clients_list,
              close_stacked_drawer,
            ]
            streams << refresh_parent_drawer(@request) if from_stacked_drawer?
            render turbo_stream: streams
          end
          format.html { redirect_to root_path, notice: t("flash.manage.indices.created") }
        end
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      authorize! @index
      @request = @index.request

      if @index.update(index_params)
        respond_to do |format|
          format.turbo_stream do
            streams = [
              render_toast("Index <strong>#{ERB::Util.html_escape(@index.name)}</strong> updated successfully"),
              refresh_clients_list,
            ]
            streams << refresh_parent_drawer(@request) if from_stacked_drawer?
            render turbo_stream: streams
          end
          format.html { redirect_to root_path, notice: t("flash.manage.indices.updated") }
        end
      else
        render :edit, status: :unprocessable_content
      end
    end

    def delete
      authorize! @index, to: :destroy?
      render_delete_modal(@index, manage_index_path(@index))
    end

    def destroy
      authorize! @index
      index_name = @index.name
      @request = @index.request
      @index.destroy

      respond_to do |format|
        format.turbo_stream do
          streams = [
            render_toast("Index <strong>#{ERB::Util.html_escape(index_name)}</strong> deleted successfully"),
            refresh_clients_list,
            close_modal,
            close_stacked_drawer,
          ]
          streams << refresh_parent_drawer(@request) if from_stacked_drawer?
          render turbo_stream: streams
        end
        format.html { redirect_to root_path, notice: t("flash.manage.indices.deleted") }
      end
    end

    private

    def set_index
      @index = Index.find(params[:id])
    end

    def set_request
      @request = Request.find(params[:request_id])
    end

    def index_params
      permitted = params.require(:index).permit(:name, :description, :method, :path, :status, :throttle, :template,
                                                :headers, :properties)

      # Parse JSON strings for JSONB fields
      %i[headers properties].each do |field|
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
