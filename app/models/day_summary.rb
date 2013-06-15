class DaySummary
  def self.for_month(year, month)
    for_date_range(Date.civil(year, month, 1), Date.civil(year, month, 1).end_of_month)
  end

  def self.for_date_range(start_date, end_date)
    commutes_by_date = Commute.where(['date >= ? AND date <= ?', start_date, end_date])
      .group_by(&:date)

    summaries = []
    (start_date..end_date).each do |date|
      commutes = commutes_by_date[date]
      unless date.weekend? && commutes.blank? 
        summaries << DaySummary.new(commutes, date)
      end
    end
    summaries.sort {|s1, s2| s1.date <=> s2.date}
  end

  def initialize(commutes, date)
    @commutes = commutes || []
    @date = date
  end

  def date
    @date
  end

  def get_driver_for(user)
    @commutes.each do |commute|
      return commute.driver if commute.user_went? user
    end

    return nil
  end
end
