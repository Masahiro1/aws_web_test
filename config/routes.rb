Rails.application.routes.draw do
  get    'secret',  to:  'main#secret'
  get    'calc',    to:  'main#calc'
  get    'stocker', to: 'main#stocker'

  root 'main#home'
end
