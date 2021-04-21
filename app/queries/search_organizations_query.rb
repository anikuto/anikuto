# frozen_string_literal: true

class SearchOrganizationsQuery
  def initialize(
    collection = Organization.all,
    anikuto_ids: nil,
    names: nil,
    order_by: nil
  )
    @collection = collection.only_kept
    @args = {
      anikuto_ids: anikuto_ids,
      names: names,
      order_by: order_by
    }
  end

  def call
    from_arguments
  end

  private

  def from_arguments
    %i(
      anikuto_ids
      names
    ).each do |arg_name|
      next if @args[arg_name].nil?
      @collection = send(arg_name)
    end

    if @args[:order_by]
      direction = @args[:order_by][:direction]

      @collection = case @args[:order_by][:field]
      when "CREATED_AT"
        @collection.order(created_at: direction)
      when "FAVORITE_ORGANIZATIONS_COUNT"
        @collection.order(favorite_users_count: direction)
      end
    end

    @collection
  end

  def anikuto_ids
    @collection.where(id: @args[:anikuto_ids])
  end

  def names
    @collection.ransack(name_or_name_kana_cont_any: @args[:names]).result
  end
end
