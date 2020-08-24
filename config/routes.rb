# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :master_servers do
    resources :accounts
    resources :worlds
  end

  resources :worlds, only: [:show] do
    resources :players
  end
end
