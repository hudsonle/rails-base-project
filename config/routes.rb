Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: redirect('/health')
  get 'health', to: 'health#show'

  extend ApiRoutes unless ENV['ATTACHED_API'].to_i.zero?
  extend AdminRoutes unless ENV['ATTACHED_ADMIN'].to_i.zero?
  extend SidekiqRoutes unless ENV['ATTACHED_SIDEKIQ'].to_i.zero?

  # Note: declare new routes above this line
  get "/", to: "application#render_200"
  post "/", to: "application#render_404"
  put "/", to: "application#render_404"
  delete "/", to: "application#render_404"
  patch "/", to: "application#render_404"
  get "*a", to: "application#render_404"
  post "*a", to: "application#render_404"
  put "*a", to: "application#render_404"
  delete "*a", to: "application#render_404"
  patch "*a", to: "application#render_404"
end
