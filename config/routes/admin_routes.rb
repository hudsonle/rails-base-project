# config/routes/admin_routes.rb
# frozen_string_literal: true

module AdminRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :admin do
        api_version(module: "V1", header: {name: "X-API-VERSION", value: "v1"}) do

        end
      end
    end
  end
end
