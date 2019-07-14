Rails.application.routes.draw do
  get    'secret', to: 'main#secret'

  root 'main#home'
end
