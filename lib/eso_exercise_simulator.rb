module AWRY
  class ESOExerciseSimulator
    def self.spread(options_agreements, market_price, exercise_date=Date.today)
      new(options_agreements, market_price, exercise_date).spread
    end

    def initialize(options_agreements, market_price, exercise_date)
      @options_agreements = options_agreements.map{ |e| VestedAgreement.new(e, exercise_date) }
      @market_price = market_price
    end

    def spread
      @options_agreements.reduce(0) do |acc, agreement|
        acc += (@market_price - agreement.strike_price) * agreement.vested_stock
      end
    end

    private

    class VestedAgreement < SimpleDelegator
      def initialize(agreement, exercise_date)
        @exercise_date = exercise_date
        super(agreement)
      end

      def vested_stock
        (stock * vested_portion).floor
      end

      private

      def vested_portion
        return 0.0 if cliff_in_progress?

        cliff_release_portion + (vested_months * vested_monthly)
      end

      def cliff_in_progress?
        @exercise_date < cliff_ends_at
      end

      def vested_months
        @exercise_date.month - cliff_ends_at.month + 12 * (@exercise_date.year - cliff_ends_at.year)
      end
    end
  end
end
