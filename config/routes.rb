Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get 'home/show'
  root 'top#index'

  resource :user, only: [:edit, :update] do
    resources :organizations, only: :index, controller: 'user_organizations'
    resources :projects, only: :index, controller: 'user_projects'
  end

  resources :organizations, only: [:new, :create, :show] do
    member do
      get :dashboard
      post :contact
    end

    resources :members, only: [:create, :destroy, :update], controller: 'organization_members' do
      member do
        patch :revoke
      end
    end

    collection do
      get :search
    end

    resources :projects, only: [:new, :create, :show] do
      resources :members, only: [:create, :destroy, :update], controller: 'project_members' do
        member do
          patch :revoke
        end
      end
    end
  end

  resources :profit_losses do
    resources :costs, only: %i(new create index show) do
      resources :cost_details, only: %i(new create show)
    end

    resources :sales, only: %i(new create index show) do
      resources :sale_details, only: %i(new create show)
    end
  end

end
