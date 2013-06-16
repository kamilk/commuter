class DateRangeValidator < ActiveModel::Validator
  def validate(record)
    return if record.from.nil? || record.to.nil?

    if record.from > record.to
      record.errors[:to] = "must come after From."
    end
  end
end
