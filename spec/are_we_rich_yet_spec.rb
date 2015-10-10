require 'eso_exercise_simulator'
require 'options_agreement'

describe 'AWRY calculates the spread' do
  let(:simulator) { AWRY::ESOExerciseSimulator }
  let(:market_price) { 30.0 }

  context 'vested quantity is based on the grant date' do
    it 'spread is positive after the cliff' do
      agreement = AWRY::OptionsAgreement.new(
        stock: 5_000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct: 100.0,
        cliff_n_months: 1,
        vesting_period: 24
      )
      date_after_cliff = Date.new(2013, 2, 21)

      spread = simulator.spread(agreement, market_price, date_after_cliff)

      expect(spread).to eql(100_000.0)
    end

    it 'spread is zero before the cliff ends' do
      agreement = AWRY::OptionsAgreement.new(
        stock: 5000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct: 100.0,
        cliff_n_months: 12,
        vesting_period: 0
      )
      date_before_cliff_ends = Date.new(2013, 3, 21)

      spread = simulator.spread(agreement, market_price, date_before_cliff_ends)

      expect(spread).to eql(0.0)
    end

    context 'vested pct is released within a schedule' do
      it 'stock is vested monthly after the cliff' do
        agreement = AWRY::OptionsAgreement.new(
          stock: 5_000.0,
          strike_price: 10.0,
          grant_date: Date.new(2013, 1, 21),
          cliff_pct: 30.0,
          cliff_n_months: 12,
          vesting_period: 24
        )
        date_2_months_after_cliff_ends = Date.new(2014, 3, 21)

        spread = simulator.spread(agreement, market_price, date_2_months_after_cliff_ends)

        expect(spread).to eql(35833.333333333336)
      end
    end
  end
end
