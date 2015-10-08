require 'awry'

describe 'AWRY' do
  it 'calculates the spread' do
      agreement = OptionsAgreement.new(
        stock: 5000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct: 100.0,
        cliff_n_months: 1
      )

    spread = AWRY.spread(agreement, 30.0, Date.today)

    expect(spread).to eql(100000.0)
  end

  context 'vested quantity is based on the grant date' do
    it 'spread is positive after the cliff' do
      agreement = OptionsAgreement.new(
        stock: 5000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct: 100.0,
        cliff_n_months: 1
      )

      spread = AWRY.spread(agreement, 30.0, Date.new(2014, 1, 21))

      expect(spread).to be > 0.0
    end

    it 'spread is zero before the cliff' do
      agreement = OptionsAgreement.new(
        stock: 5000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct: 100.0,
        cliff_n_months: 12
      )

      spread = AWRY.spread(agreement, 30.0, Date.new(2013, 3, 21))

      expect(spread).to eql(0.0)
    end

    it 'the cliff releases a vested pct' do
      agreement = OptionsAgreement.new(
        stock: 5000.0,
        strike_price: 10.0,
        grant_date: Date.new(2013, 1, 21),
        cliff_pct:30.0,
        cliff_n_months: 12
      )

      spread = AWRY.spread(agreement, 30.0, Date.new(2015, 3, 21))

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

        spread = AWRY.spread(agreement, 30.0, Date.new(2015, 3, 21))

        expect(spread).to eql(30_000.00)
      end
    end
  end
end
