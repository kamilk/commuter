module CommutesHelper
  def previous_month_path
    prev_month = @month - 1
    prev_year = @year
    if prev_month == 0
      prev_month = 12
      prev_year -= 1
    end
    "#{commutes_path}/#{prev_year}/#{prev_month}"
  end

  def next_month_path
    next_month = @month + 1
    next_year = @year
    if next_month == 13
      next_month = 1
      next_year += 1
    end
    "#{commutes_path}/#{next_year}/#{next_month}"
  end
end
