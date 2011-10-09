Rails.application.routes.draw do

  scope '(:locale)', :constraints => {:locale => /de|en/} do
  
    resources :courses do
      resources :comments
    end
    
  end
end
