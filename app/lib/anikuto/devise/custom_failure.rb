# frozen_string_literal: true
# https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-when-the-user-can-not-be-authenticated

module Anikuto
  module Devise
    class CustomFailure < ::Devise::FailureApp
      def redirect_url
        sign_in_url
      end
    end
  end
end
