class DebtLogEntry
  attr_accessor :commute
  attr_accessor :amount
  attr_accessor :from_user
  attr_accessor :to_user

  def initialize(from_user, to_user, commute, amount: nil)
    @from_user = from_user
    @to_user = to_user
    @amount = amount || 0
    @commute = commute
    @certain = !amount.nil?
  end

  def certain?
    @certain
  end
end
