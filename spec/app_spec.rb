require 'rack/test'
require_relative '../app'

describe 'App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it '/spread' do
    agreement = AWRY::OptionsAgreement.new(
      stock: 12,
      strike_price: 34,
      grant_date: Date.parse('2014-12-12'),
      cliff_pct: 56,
      cliff_n_months: 7,
      vesting_period: 8
    )

    expect(AWRY::ESOExerciseSimulator).to receive(:spread).
      with(agreement, 123.45, Date.today).
      and_return(7)

    post '/spread', params={'market_price' => 123.45,
                            'stocks' => agreement.stock,
                            'strikeprice' => agreement.strike_price,
                            'grantdate' => '2014-12-12',
                            'cliff_pct' => agreement.cliff_pct,
                            'cliff_n_months' => agreement.cliff_n_months,
                            'vesting_period' => agreement.vesting_period }

    expect(last_response.ok?).to eql(true)
  end
end