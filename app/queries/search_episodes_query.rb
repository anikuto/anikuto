# frozen_string_literal: true

class SearchEpisodesQuery
  def initialize(
    collection = Episode.all,
    anikuto_ids: nil,
    order_by: nil
  )
    @collection = collection.only_kept
    @args = {
      anikuto_ids: anikuto_ids,
      order_by: order_by
    }
  end

  def call
    from_arguments
  end

  private

  def from_arguments
    apply_filters

    if @args[:order_by].present?
      direction = @args[:order_by][:direction]

      @collection = case @args[:order_by][:field]
      when 'CREATED_AT'
        @collection.order(created_at: direction)
      when 'SORT_NUMBER'
        @collection.order(sort_number: direction)
      end
    end

    @collection
  end

  def apply_filters
    %i(
      anikuto_ids
    ).each do |arg_name|
      next if @args[arg_name].nil?

      @collection = send(arg_name)
    end
  end

  def anikuto_ids
    @collection.where(id: @args[:anikuto_ids])
  end
end
