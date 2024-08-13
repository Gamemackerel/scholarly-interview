# config/routes.rb
Rails.application.routes.draw do
  resources :professors, only: [:index, :show] do
    member do
      post 'fetch_projects'
    end
  end

  root 'professors#index'
end