class DaySummary
  def initialize(commutes, date)
    @commutes = commutes 
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

  def self.for_date_range(start_date, end_date)
    commutes_by_date = Commute.where(['date >= ? AND date <= ?', start_date, end_date])
      .group_by(&:date)

    summaries = []
    commutes_by_date.each do |date, commutes|
      summaries << DaySummary.new(commutes, date)
    end
    summaries
  end
end
