# frozen_string_literal: true

module Manage
  class IndicesController < BaseController
    before_action :set_index, only: %i[edit update destroy delete]
    before_action :set_request, only: %i[new create]

    def new
      @index = @request.indices.new(status: 200, method: "GET")
      authorize! @index
    end

    def create
      @index = @request.indices.new(index_params)
      authorize! @index

      if @index.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              render_toast("Index '#{@index.name}' created successfully"),
              turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) }),
              close_stacked_drawer
            ]
          end
          format.html { redirect_to root_path, notice: "Index created successfully" }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize! @index
      @request = @index.request
    end

    def update
      authorize! @index

      if @index.update(index_params)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              render_toast("Index '#{@index.name}' updated successfully"),
              turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) })
            ]
          end
          format.html { redirect_to root_path, notice: "Index updated successfully" }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def delete
      authorize! @index, to: :destroy?
      render_delete_modal(@index, manage_index_path(@index))
    end

    def destroy
      authorize! @index
      index_name = @index.name
      @index.destroy

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            render_toast("Index '#{index_name}' deleted successfully"),
            turbo_stream.replace("clients", partial: "dashboard/endpoints/clients", locals: { clients: Client.includes(requests: [:responses, :indices]).order(:name) }),
            close_modal,
            close_stacked_drawer,
            close_drawer
          ]
        end
        format.html { redirect_to root_path, notice: "Index deleted successfully" }
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
      permitted = params.require(:index).permit(:name, :description, :method, :path, :status, :throttle, :template, :headers, :properties)
      
      # Parse JSON strings for JSONB fields
      %i[headers properties].each do |field|
        if permitted[field].is_a?(String)
          permitted[field] = JSON.parse(permitted[field]) rescue {}
        end
      end
      
      permitted
    end
  end
end
