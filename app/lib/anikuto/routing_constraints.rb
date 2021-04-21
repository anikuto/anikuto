# frozen_string_literal: true

module Anikuto
  module RoutingConstraints
    class Member
      def matches?(request)
        request.session['warden.user.user.key'].present?
      end
    end

    class Guest
      def matches?(request)
        !Anikuto::RoutingConstraints::Member.new.matches?(request)
      end
    end
  end
end
