class FuelReportValidator < ActiveModel::Validator
  def validate(record)
    return unless record.errors[:from].blank? && record.errors[:to].blank?

    # If reports r1 and r2 do *not* overlap, than r1.to < r2.from || r1.from > r2.to
    # The condition below is this one negated. record is r2.
    if FuelReport.where(['user_id = ? AND "to" >= ? AND "from" <= ?', record.user_id, record.from, record.to]).exists?
      record.errors[:base] << "The new fuel report overlaps with one of your existing reports."
    end
  end
end
