# frozen_string_literal: true

Rails.application.config.middleware.use(OmniAuth::Builder) do
  provider(
    :okta,
    ENV.fetch("OKTA_CLIENT_ID", nil),
    ENV.fetch("OKTA_CLIENT_SECRET", nil),
    {
      scope: "openid profile email",
      client_options: {
        site: ENV.fetch("OKTA_SITE", nil),
        authorize_url: "#{ENV.fetch('OKTA_SITE', nil)}/oauth2/default/v1/authorize",
        token_url: "#{ENV.fetch('OKTA_SITE', nil)}/oauth2/default/v1/token",
        user_info_url: "#{ENV.fetch('OKTA_SITE', nil)}/oauth2/default/v1/userinfo",
      },
      redirect_uri: ENV.fetch("OKTA_REDIRECT_URI", nil),
    },
  )
end
