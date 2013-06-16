class GreaterThanValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    greater_than_value = options[:with]
    if value <= greater_than_value 
      record.errors[attribute] << "must be greater than #{greater_than_value}"
    end
  end
end
