class FuelReportValidator < ActiveModel::Validator
  def validate(record)
    return unless record.errors[:from_date].blank? && record.errors[:to_date].blank?

    # If reports r1 and r2 do *not* overlap, than r1.to < r2.from || r1.from > r2.to
    # The condition below is this one negated. record is r2.
    reports = FuelReport.where(['user_id = ? AND to_date >= ? AND from_date <= ?', record.user_id, record.from_date, record.to_date])
    unless record.new_record?
      reports = reports.where(['id != ?', record.id])
    end

    if reports.exists?
      record.errors[:base] << "The new fuel report overlaps with one of your existing reports."
    end
  end
end
