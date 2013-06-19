class DateRangeValidator < ActiveModel::Validator
  def validate(record)
    return if record.from_date.nil? || record.to_date.nil?

    if record.from_date > record.to_date
      record.errors[:to_date] = "must come after From."
    end
  end
end
