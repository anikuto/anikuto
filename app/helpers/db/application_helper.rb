# frozen_string_literal: true
module Db
  module ApplicationHelper
    def select_diff_by_field(diffs, field)
      diffs.select { |diff| diff[1] == field.to_s }.first
    end
  end
end
