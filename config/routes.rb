# frozen_string_literal: true

Rails.application.routes.draw do
  resources :follows, only: %i[create destroy]
  resources :sleep_records, only: %[index] do
    collection do
      post :sleep
      post :wakeup
      get :followee_last_week
    end
  end
end
