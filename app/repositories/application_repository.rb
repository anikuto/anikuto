# frozen_string_literal: true

class ApplicationRepository
  module Types
    include Dry.Types()
  end

  class MutationError < Dry::Struct
    attribute :message, Types::String
  end

  def initialize(graphql_client:)
    @graphql_client = graphql_client
  end

  private

  attr_reader :graphql_client

  def file_name
    @file_name ||= "#{self.class.name.split('::').map do |str|
                        str.camelize(:lower)
                      end.join('/').delete_suffix('Repository')}.graphql"
  end

  def query_definition
    @query_definition ||= File.read(Rails.root.join('app', 'lib', 'anikuto', 'graphql', 'queries', file_name))
  end

  def mutation_definition
    @mutation_definition ||= File.read(Rails.root.join('app', 'lib', 'anikuto', 'graphql', 'mutations', file_name))
  end

  def camelized_variables(variables)
    variables.deep_transform_keys { |key| key.to_s.camelize(:lower) }
  end

  def query(variables: {})
    graphql_client.execute(query_definition, variables: camelized_variables(variables))
  end

  def mutate(variables: {})
    graphql_client.execute(mutation_definition, variables: camelized_variables(variables))
  end
end
