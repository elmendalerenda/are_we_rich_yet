require 'awry'
require 'options_agreement'

describe 'AWRY calculates the spread' do
  let(:market_price) { 30.0 }

  context 'vested quantity is based on the grant date' do
    it 'spread is positive after the cliff' do
      agreement = OptionsAgreement.new(
        stock: 5000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct: 100.0,
        cliff_n_months: 1
      )
      date_after_cliff = Date.new(2013, 2, 21)

      spread = AWRY.spread(agreement, market_price, date_after_cliff)

      expect(spread).to eql(100_000.0)
    end

    it 'spread is zero before the cliff ends' do
      agreement = OptionsAgreement.new(
        stock: 5000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct: 100.0,
        cliff_n_months: 12
      )
      date_before_cliff_ends = Date.new(2013, 3, 21)

      spread = AWRY.spread(agreement, market_price, date_before_cliff_ends)

      expect(spread).to eql(0.0)
    end

    it 'the cliff releases a vested pct when it ends' do
      agreement = OptionsAgreement.new(
        stock: 5000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct:30.0,
        cliff_n_months: 12
      )
      date_after_cliff = Date.new(2015, 3, 21)

      spread = AWRY.spread(agreement, market_price, date_after_cliff)

      expect(spread).to eql(30_000.00)
    end

    context 'vested pct is released within a schedule' do
      it 'stock is vested monthly after the cliff' do
        agreement = OptionsAgreement.new(
          stock: 5_000.0,
          strike_price: 10.0,
          grant_date: Date.new(2013, 1, 21),
          cliff_pct: 30.0,
          cliff_n_months: 12,
          vesting_period: 24,
          vesting_rate_after_cliff: :monthly
        )

        spread = AWRY.spread(agreement, market_price, Date.new(2015, 3, 21))

        expect(spread).to eql(30_000.00)
      end
    end
  end
end
