class DebtLog
  def self.from_commutes(commutes)
    log = self.new
    commutes.each do |commute|
      log.add_commute(commute)
    end
    log
  end

  def initialize
    @entries = []
  end

  def add_commute(commute, report=nil)
    report = FuelReport.for_commute(commute) if report.nil?
    price_per_person = report.nil? ? nil : report.cost_of_commute_per_person(commute)
    for user in commute.users
      next if user == commute.driver
      @entries << DebtLogEntry.new(user, commute.driver, commute, amount: price_per_person)
    end
  end

  def debt_between(owing, owed)
    summary = DebtSummary.new
    @entries.each do |entry|
      if entry.from_user == owing && entry.to_user == owed
        reverse = false
      elsif entry.from_user == owed && entry.to_user == owing
        reverse = true
      else
        next
      end

      if entry.certain?
        amount = entry.amount
        amount = -amount if reverse
        summary.add(amount)
      else
        summary.uncertain!
      end
    end
    summary
  end

  def debts_between_everyone
    result = {}
    User.all.each do |owing|
      result[owing] = {}
      User.all.each do |owed|
        next if owing == owed
        result[owing][owed] = debt_between(owing, owed)
      end
    end
    result
  end
end
