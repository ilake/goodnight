Rails.application.routes.draw do
  resources :follows, only: %i[create destroy] do
    collection do
      get :sleep_records
    end
  end

  resources :sleep_records, only: %[index] do
    collection do
      post :sleep
      post :wakeup
    end
  end
end
