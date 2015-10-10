class OptionsAgreement < Struct.new(:stock, :strike_price, :grant_date, :cliff_pct, :cliff_n_months, :vesting_period)
  def initialize(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def cliff_release_portion
    cliff_pct / 100.0
  end

  def vested_monthly
    (1.0 - cliff_release_portion) / vesting_period
  end

  def cliff_ends_at
    grant_date >> cliff_n_months
  end
end
