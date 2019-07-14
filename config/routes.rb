Rails.application.routes.draw do
  namespace :main do
    get    'home'
  end

  root 'main#home'
end
