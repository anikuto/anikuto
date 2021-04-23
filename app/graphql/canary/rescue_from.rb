# frozen_string_literal: true

module Canary
  class RescueFrom
    def initialize(resolve_func)
      @resolve_func = resolve_func
    end

    def call(obj, args, ctx)
      ActiveRecord::Base.transaction do
        @resolve_func.call(obj, args, ctx)
      end
    rescue StandardError => e
      message = case e
      when ActiveRecord::RecordNotFound
        "Couldn't find #{e.model} with #{e.id}"
      else
        e.message
      end

      GraphQL::ExecutionError.new(message)
    end
  end
end
