# frozen_string_literal: true

module Anikuto
  module Errors
    class AnikutoError < StandardError; end

    class InvalidAPITokenScopeError < AnikutoError; end

    class ModelMismatchError < AnikutoError; end
  end
end
