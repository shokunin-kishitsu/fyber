FyberDeveloperChallenge::Application.routes.draw do

  post 'offers' => 'main#get_offers'
  root :to => 'main#index'

end
