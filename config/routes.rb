Rails.application.routes.draw do
  get    'secret', to: 'main#secret'
  get    'calc',   to: 'main#calc'

  root 'main#home'
end
