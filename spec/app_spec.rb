require 'rack/test'
require_relative '../app'

describe 'App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it '/spread' do
    expect(AWRY::ESOExerciseSimulator).to receive(:spread).
      with(a_kind_of(AWRY::OptionsAgreement), 123.45, Date.today)

    post '/spread', params={'market_price' => 123.45,
      'stocks' => 12,
      'strikeprice' => 34,
      'grantdate' => '2014-12-12',
      'cliff_pct' => 56,
      'cliff_n_month' => 7,
      'vesting_period' => 8 }

    expect(last_response.ok?).to eql(true)
  end
end
