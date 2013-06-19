class Debt
  def self.all_by_user
    debts_by_user = {}
    commutes = Commute.all
    commutes.each do |commute|
      report = FuelReport.for_commute(commute)
      next if report.nil?
      price_per_person = 60 * report.price_per_km / commute.number_of_people
      commute.users.each do |user|
        debts_by_user[user] = Debt.new if debts_by_user[user].nil?
        debts_by_user[user].add(commute.driver, price_per_person)
      end
    end
    debts_by_user
  end

  def initialize
    @debt_by_user = {}
  end

  def add(user, amount)
    @debt_by_user[user] = 0 if @debt_by_user[user].nil?
    @debt_by_user[user] += amount
  end
  
  def owed_to(user)
    @debt_by_user[user] || 0
  end
end
