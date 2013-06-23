class Debt
  def self.all_by_user
    DebtFetcher.new.all_by_user
  end

  def initialize
    @debt_by_user = {}
    @reverse_debt_by_user = {}
    @uncertain_by_user = {}
  end

  def add_owed_to(user, amount)
    @debt_by_user[user] = 0 if @debt_by_user[user].nil?
    @debt_by_user[user] += amount
  end

  def subtract_owed_by(user, amount)
    @reverse_debt_by_user[user] = 0 if @reverse_debt_by_user[user].nil?
    @reverse_debt_by_user[user] += amount
  end
  
  def mark_as_uncertain(user)
    @uncertain_by_user[user] = true
  end

  def owed_to(user)
    result = (@debt_by_user[user] || 0) - (@reverse_debt_by_user[user] || 0)
    return result >= 0 ? result : 0
  end

  def uncertain?(user)
    @uncertain_by_user[user] || false
  end
end
