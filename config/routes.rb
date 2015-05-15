Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get 'home/show'
  root 'home#index'

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

end
