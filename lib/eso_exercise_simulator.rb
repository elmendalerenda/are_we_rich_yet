module AWRY
  class ESOExerciseSimulator
    def self.spread(options_agreements, market_price, exercise_date=Date.today)
      new(options_agreements, market_price, exercise_date).spread
    end

    def initialize(options_agreements, market_price, exercise_date)
      @options_agreements = options_agreements
      @market_price = market_price
      @exercise_date = exercise_date
    end

    def spread
      @options_agreements.reduce(0) do |acc, agreement|
        (@market_price - agreement.strike_price) * vested_stock(agreement)
      end
    end

    private

    def vested_stock(agreement)
      (agreement.stock * vested_portion(agreement)).floor
    end

    def vested_portion(agreement)
      return 0.0 if cliff_in_progress?(agreement)

      agreement.cliff_release_portion + (vested_months(agreement) * agreement.vested_monthly)
    end

    def cliff_in_progress?(agreement)
      @exercise_date < agreement.cliff_ends_at
    end

    def vested_months(agreement)
      @exercise_date.month - agreement.cliff_ends_at.month + 12 * (@exercise_date.year - agreement.cliff_ends_at.year)
    end
  end
end
