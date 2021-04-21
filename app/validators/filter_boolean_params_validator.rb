# frozen_string_literal: true

class FilterBooleanParamsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless value =~ /\A(true|false)\z/
      message = I18n.t('messages._validators.is_required_true_or_false')
      record.errors.add(attribute, message)
    end
  end
end
