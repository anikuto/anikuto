# frozen_string_literal: true

namespace :api do
  namespace :internal do
    post :graphql, to: 'graphql#execute'

    resource :impression, only: %i(show update)
    resource :privacy_policy_agreement, only: %i(create)
    resource :slots_sort_type, only: [:update]
    resource :records_sort_type, only: %i(update)
    resource :search, only: [:show]
    resources :characters, only: [:index]
    resources :mute_users, only: [:create]
    resources :organizations, only: [:index]
    resources :people, only: [:index]
    resources :receptions, only: %i(create destroy)
    resources :series_list, only: %i(index)
    resources :works, only: %i(index show)

    resources :episodes, only: [] do
      resources :records, only: %i(create), controller: :episode_records
    end

    resources :favorites, only: %i(create) do
      post :unfavorite, on: :collection
    end

    resources :follows, only: %i(create) do
      post :unfollow, on: :collection
    end

    resources :library_entries, only: [] do
      patch :skip_episode
    end

    resources :likes, only: [:create] do
      post :unlike, on: :collection
    end

    resources :multiple_records, only: %i(create)

    resources :reactions, only: [] do
      post :add, on: :collection
      post :remove, on: :collection
    end

    resources :statistics, only: [] do
      get :user_heatmap, on: :collection
    end

    resource :user, only: [] do
      resources :slots, only: [:index], controller: 'user_slots'
    end

    resources :works, only: [] do
      resource :library_entry, only: [:show]
      resource :status_chart_data, only: %i(show)
      resource :watchers_chart_data, only: %i(show)

      resources :channels, only: [] do
        post :select, on: :collection
      end

      resources :statuses, only: [] do
        post :select, on: :collection
      end
    end
  end
end

scope module: :api do
  scope module: :internal do
    constraints format: 'json' do
      match '/api/internal/following', via: :get, as: :internal_api_following_list, to: 'following#index'
      match '/api/internal/library_entries',   via: :get, as: :internal_api_library_entry_list,
                                               to: 'library_entries#index'
      match '/api/internal/likes',             via: :get, as: :internal_api_like_list, to: 'likes#index'
      match '/api/internal/tracked_resources', via: :get, as: :internal_api_tracked_resource_list,
                                               to: 'tracked_resources#index'
      match '/api/internal/user',              via: :get, as: :internal_api_user_detail, to: 'users#show'
      match '/api/internal/work_friends',      via: :get, as: :internal_api_work_friend_list,
                                               to: 'work_friends#index'
    end

    constraints format: 'html' do
      match '/api/internal/activities', via: :get, as: :internal_api_activity_list, to: 'activities#index'
    end
  end
end
