# frozen_string_literal: true

# validates password with the rules tribalwars uses
class TribalwarsPasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << 'Password must be at least 8 characters long' if value.nil? || value.length < 8
    record.errors[attribute] << 'Password must contain at least 1 digit' unless value =~ /[0-9]/
  end
end
