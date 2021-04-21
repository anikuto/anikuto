# frozen_string_literal: true

class CallbacksController < Devise::OmniauthCallbacksController
  before_action :authorize, only: %i(facebook twitter)

  def facebook; end

  def twitter; end

  private

  def authorize
    auth = request.env['omniauth.auth']
    omni_params = request.env['omniauth.params']
    provider = Provider.find_by(name: auth[:provider], uid: auth[:uid])

    if provider
      user = provider.user

      if !user.confirmed? && user.registered_after_email_confirmation_required?
        return redirect_to root_path, alert: t('devise.failure.user.unconfirmed')
      end

      provider.attributes = provider_attributes(auth)
      provider.save
      redirect_path = omni_params['back'].presence || after_sign_in_path_for(user)
      sign_in user

      return redirect_to redirect_path
    end

    if user_signed_in?
      current_user.providers.create(provider_attributes(auth))
      redirect_path = omni_params['back'].presence || root_path
      bypass_sign_in(current_user)

      return redirect_to redirect_path, notice: t('messages._common.connected')
    end

    redirect_to root_path, alert: t('messages.callbacks.sign_in_failed')
  end

  def provider_attributes(auth)
    credentials = auth[:credentials]

    {
      name: auth[:provider],
      uid: auth[:uid],
      token: credentials[:token],
      token_expires_at: (auth[:provider] == 'facebook' ? credentials[:expires_at] : nil),
      token_secret: (auth[:provider] == 'twitter' ? credentials[:secret] : nil)
    }
  end

  def after_omniauth_failure_path_for(scope)
    root_path(scope)
  end
end
