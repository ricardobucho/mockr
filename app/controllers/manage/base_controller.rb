# frozen_string_literal: true

module Manage
  class BaseController < ApplicationController
    include ActionPolicy::Controller

    authorize :user, through: :current_user

    layout false

    private

    def render_toast(message, type: :success)
      turbo_stream.prepend("toast-container", Manage::ToastComponent.new(message: message, type: type))
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

    def from_stacked_drawer?
      turbo_frame_request_id == "drawer-stacked"
    end

    def render_delete_modal(resource, delete_path)
      render partial: "manage/shared/delete_modal", locals: {
        resource_name: resource.respond_to?(:name) ? resource.name : resource.class.name,
        delete_url: delete_path
      }
    end
  end
end
