module AWRY
  class ESOExerciseSimulator
    def self.spread(options_agreement, market_price, exercise_date=Date.today)
      new(options_agreement, market_price, exercise_date).spread
    end

    def initialize(options_agreement, market_price, exercise_date)
      @options_agreement = options_agreement
      @market_price = market_price
      @exercise_date = exercise_date
    end

    def spread
      (@market_price - @options_agreement.strike_price) * @options_agreement.stock * vested_portion
    end

    private

    def vested_portion
      return 0.0 if cliff_in_progress?

      @options_agreement.cliff_release_portion + (vested_months * @options_agreement.vested_monthly)
    end

    def cliff_in_progress?
      @exercise_date < @options_agreement.cliff_ends_at
    end

    def vested_months
      @exercise_date.month - @options_agreement.cliff_ends_at.month + 12 * (@exercise_date.year - @options_agreement.cliff_ends_at.year)
    end
  end
end
