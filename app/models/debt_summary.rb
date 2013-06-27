class DebtSummary
  attr_accessor :amount

  def initialize
    @amount = 0
    @certain = true
  end

  def amount_non_negative
    amount >= 0 ? amount : 0
  end

  def certain?
    @certain 
  end

  def add(amount)
    @amount += amount
  end

  def uncertain!
    @certain = false
  end
end
