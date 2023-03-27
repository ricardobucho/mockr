class DashboardController < ApplicationController
  def index
    @method_class_map = {
      "GET" => "success",
      "POST" => "info",
      "PUT" => "warning",
      "PATCH" => "warning",
      "DELETE" => "danger",
    }
  end
end
