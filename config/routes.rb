Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  use_doorkeeper do
    # No need to register client application
    skip_controllers :applications, :authorized_applications
  end

  root to: 'about#show', defaults: { format: 'json' }

  scope :api, defaults: { format: 'json' } do
    scope :v1 do
      devise_for :users,
                 controllers: {
                   registrations: 'api/v1/users/registrations',
                   confirmations: 'api/v1/users/confirmations',
                   unlocks:       'api/v1/users/unlocks'
                 },
                 skip: %i[sessions password]
    end
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      namespace :admin do
        resources :authors,     except: %i[new edit]
        resources :books,       except: %i[new edit]
        resources :publishers,  except: %i[new edit]
      end

      resources :shops, only: [] do
        resources :sales, only: [:create]
      end

      resources :publishers, only: [] do
        resources :shops, only: [:index]
      end
    end
  end
end
