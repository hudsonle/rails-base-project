# config/routes/admin_routes.rb
# frozen_string_literal: true

module SidekiqRoutes
  def self.extended(router)
    router.instance_exec do
      require 'sidekiq/web'
      Sidekiq::Web.use ActionDispatch::Cookies
      Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"
      mount Sidekiq::Web, at: '/sidekiq'
    end
  end
end
