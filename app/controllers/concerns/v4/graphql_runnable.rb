# frozen_string_literal: true

module V4
  module GraphqlRunnable
    def graphql_client(viewer: nil)
      @graphql_client ||= Anikuto::Graphql::InternalClient.new(
        viewer: viewer
      )
    end
  end
end
