class DebtFetcher
  def initialize
    @debts_by_user = {}
  end

  def all_by_user
    commutes = Commute.all
    commutes.each do |commute|
      report = FuelReport.for_commute(commute)
      if report.nil?
        mark_as_uncertain(commute)
      else
        update_debts(commute, report)
      end
    end
    @debts_by_user
  end

  private

  def debt_for_user(user)
    @debts_by_user[user] = Debt.new if @debts_by_user[user].nil?
    @debts_by_user[user]
  end

  def mark_as_uncertain(commute)
    commute.users.each do |user|
      debt_for_user(user).mark_as_uncertain(commute.driver)
      debt_for_user(commute.driver).mark_as_uncertain(user)
    end
  end

  def update_debts(commute, report)
    price_per_person = 60 * report.price_per_km / commute.number_of_people
    commute.users.each do |user|
      debt_for_user(user).add_owed_to(commute.driver, price_per_person)
      debt_for_user(commute.driver).subtract_owed_by(user, price_per_person)
    end
  end
end
