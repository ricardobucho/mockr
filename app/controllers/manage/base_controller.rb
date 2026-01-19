# frozen_string_literal: true

module Manage
  class BaseController < ApplicationController
    include ActionPolicy::Controller

    authorize :user, through: :current_user

    layout false

    rescue_from ActionPolicy::Unauthorized, with: :handle_unauthorized

    private

    def handle_unauthorized
      respond_to do |format|
        format.html { redirect_to root_path, alert: t("flash.unauthorized") }
        format.turbo_stream { head :forbidden }
        format.json { render json: { error: "Unauthorized" }, status: :forbidden }
      end
    end

    def render_toast(message = nil, type: :success, resource_type: nil, resource_name: nil, action: nil)
      turbo_stream.prepend(
        "toast-container",
        Manage::ToastComponent.new(
          message: message,
          type: type,
          resource_type: resource_type,
          resource_name: resource_name,
          action: action,
        ),
      )
    end

    def close_drawer
      turbo_stream.update("drawer", "")
    end

    def close_stacked_drawer
      turbo_stream.update("drawer-stacked", "")
    end

    def close_modal
      turbo_stream.update("modal", "")
    end

    def refresh_parent_drawer(request)
      turbo_stream.replace("drawer", partial: "manage/requests/edit_drawer", locals: { request: request })
    end

    def refresh_clients_drawer
      turbo_stream.update("drawer", partial: "manage/clients/drawer_content",
                                    locals: { clients: Client.includes(requests: %i[indices responses]).order(:name) })
    end

    def from_stacked_drawer?
      turbo_frame_request_id == "drawer-stacked"
    end

    def render_delete_modal(resource, delete_path)
      render partial: "manage/shared/delete_modal", locals: {
        resource_name: resource.respond_to?(:name) ? resource.name : resource.class.name,
        delete_url: delete_path,
      }
    end

    def refresh_clients_list
      turbo_stream.replace(
        "clients",
        partial: "dashboard/endpoints/clients",
        locals: { clients: Client.includes(requests: %i[responses indices]).order(:name) },
      )
    end
  end
end
