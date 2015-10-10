class AWRY
  def self.spread(options_agreement, market_price, exercise_date=Date.today)
    (market_price - options_agreement.strike_price) * options_agreement.stock * options_agreement.vested_portion(exercise_date)
  end
end

