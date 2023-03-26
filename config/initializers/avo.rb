# For more information regarding these settings check out our docs https://docs.avohq.io
Avo.configure do |config|
  ## == Routing ==
  config.root_path = "/manage"

  # Where should the user be redirected when visting the `/avo` url
  # config.home_path = nil

  ## == Licensing ==
  config.license = "community" # change this to "pro" when you add the license key
  # config.license_key = ENV["AVO_LICENSE_KEY"]

  ## == Set the context ==
  config.set_context do
    self.class.include Authentication
  end

  ## == Authentication ==
  config.current_user_method = :current_user

  # config.current_user_resource_name = :current_user

  # config.authenticate_with do
  #   redirect_to root_path unless current_user.manager?
  # end

  ## == Authorization ==
  config.authorization_client = :pundit

  config.authorization_methods = {
    index: "index?",
    show: "show?",
    edit: "edit?",
    new: "new?",
    update: "update?",
    create: "create?",
    destroy: "destroy?",
  }

  config.raise_error_on_missing_policy = true

  ## == Localization ==
  # config.locale = "en-US"

  ## == Resource options ==
  # config.resource_controls_placement = :right
  # config.model_resource_mapping = {}
  # config.default_view_type = :table
  # config.per_page = 24
  # config.per_page_steps = [12, 24, 48, 72]
  # config.via_per_page = 8
  # config.id_links_to_resource = false
  # config.cache_resources_on_index_view = true
  ## permanent enable or disable cache_resource_filters, default value is false
  # config.cache_resource_filters = false
  ## provide a lambda to enable or disable cache_resource_filters per user/resource.
  # config.cache_resource_filters = ->(current_user:, resource:) { current_user.cache_resource_filters?}

  ## == Customization ==
  config.app_name = "Mockr"
  # config.timezone = "UTC"
  # config.currency = "USD"
  # config.hide_layout_when_printing = false
  # config.full_width_container = false
  # config.full_width_index_view = false
  # config.search_debounce = 300
  # config.view_component_path = "app/components"
  # config.display_license_request_timeout_error = true
  # config.disabled_features = []
  # config.resource_controls = :right
  # config.tabs_style = :tabs # can be :tabs or :pills
  # config.buttons_on_form_footers = true
  # config.field_wrapper_layout = true

  ## == Branding ==
  config.branding = {
    colors: {
      background: "245 245 245",
      100 => "#C4CDEC",
      400 => "#399EE5",
      500 => "#5064A8",
      600 => "#066BB2",
    },
    # chart_colors: ["#0B8AE2", "#34C683", "#2AB1EE", "#34C6A8"],
    logo: "mockr.svg",
    logomark: "favicon.svg",
    # placeholder: "/avo-assets/placeholder.svg",
    favicon: "favicon.ico",
  }

  ## == Breadcrumbs ==
  config.display_breadcrumbs = true
  config.set_initial_breadcrumbs

  ## == Menus ==
  # config.main_menu = -> {
  #   section "Dashboards", icon: "dashboards" do
  #     all_dashboards
  #   end

  #   section "Resources", icon: "resources" do
  #     all_resources
  #   end
  # }
end
