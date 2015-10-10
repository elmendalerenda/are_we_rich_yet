require 'eso_exercise_simulator'
require 'options_agreement'

describe AWRY::ESOExerciseSimulator do
  let(:simulator) { described_class }
  let(:market_price) { 30.0 }
  let(:base_options_agreement) { {
        stock: 5_000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct: 100.0,
        cliff_n_months: 12,
        vesting_period: 0
  } }

  context 'before the cliff ends' do
    it 'spread is zero' do
      grant_date = Date.new(2013, 1, 21)
      date_before_cliff_ends = grant_date << 2
      agreement = AWRY::OptionsAgreement.new(
        base_options_agreement.merge(
          grant_date: grant_date,
          cliff_n_months: 12)
      )

      spread = simulator.spread(agreement, market_price, date_before_cliff_ends)

      expect(spread).to eql(0.0)
    end
  end

  context 'after the cliff ends' do
    it 'vests the cliff percentage' do
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

    it 'vests the rest of the stock monthly' do
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

      expect(spread).to eql(35_833.333333333336)
    end
  end

  describe 'the vesting schedule ends' do
    it 'vests all the stock' do
      agreement = AWRY::OptionsAgreement.new(
        stock: 5_000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct: 50.0,
        cliff_n_months: 1,
        vesting_period: 3
      )
      date_fully_vested = Date.new(2013, 5, 21)

      spread = simulator.spread(agreement, market_price, date_fully_vested)

      expect(spread).to eql(100_000.0)
    end
  end
end
