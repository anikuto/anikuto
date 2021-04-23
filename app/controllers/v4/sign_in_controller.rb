# frozen_string_literal: true

module V4
  class SignInController < V4::ApplicationController
    layout 'simple'

    before_action :redirect_if_signed_in

    def new
      if params[:back]
        store_location_for(:user, params[:back])
      end

      # From OAuth client
      if params[:client_id]
        @oauth_app = Doorkeeper::Application.available.find_by(uid: params[:client_id])
      end

      @form = SignInForm.new
      @recaptcha = Recaptcha.new(action: 'sign_in')
    end

    def create
      @form = SignInForm.new(sign_in_form_attributes)
      @recaptcha = Recaptcha.new(action: 'sign_in')

      unless @form.valid?
        return render(:new)
      end

      unless @recaptcha.verify?(params[:recaptcha_token])
        flash.now[:alert] = t('messages.recaptcha.not_verified')
        return render(:new)
      end

      EmailConfirmation.new(email: @form.email, back: @form.back).confirm_to_sign_in!

      flash[:notice] = t('messages.sign_in.create.mail_has_sent')
      redirect_to root_path
    end

    private

    def sign_in_form_attributes
      params.to_unsafe_h['sign_in_form'].merge(back: stored_location_for(:user))
    end
  end
end
