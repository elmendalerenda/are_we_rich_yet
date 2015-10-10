class OptionsAgreement

  attr_reader :strike_price, :stock

  def initialize(stock:, strike_price:, grant_date:, cliff_pct:, cliff_n_months:, vesting_period:)
    @stock = stock
    @strike_price = strike_price
    @grant_date = grant_date
    @cliff_release_portion = cliff_pct / 100.0
    @cliff_n_months = cliff_n_months
    @vesting_period = vesting_period
  end

  def vested_portion(exercise_date)
    return 0.0 if cliff_in_progress?(exercise_date)

    @cliff_release_portion + (vested_months(exercise_date) * vested_monthly)
  end

  private

  def vested_monthly
    (1.0 - @cliff_release_portion) / @vesting_period
  end

  def vested_months(date)
    date.month - cliff_ends_at.month + 12 * (date.year - cliff_ends_at.year)
  end

  def cliff_ends_at
    @grant_date >> @cliff_n_months
  end

  def cliff_in_progress?(date)
    date < cliff_ends_at
  end
end
