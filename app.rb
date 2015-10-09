require 'sinatra'
require 'json'
require './lib/awry'
require './lib/options_agreement'

get '/' do
  erb :index
end

post '/spread' do
  agreement = OptionsAgreement.new(
    stock: (params['stocks']).to_f,
    strike_price: (params['strikeprice']).to_f,
    grant_date: Date.parse(params['grantdate']),
    cliff_pct: params['cliff_pct'].to_f,
    cliff_n_months: params['cliff_n_month'].to_f,
    vesting_period: params['vesting_period'].to_f,
    vesting_rate_after_cliff: :monthly
  )

  spread = AWRY.spread(agreement, params['market_price'].to_f, Date.today)

  { spread: spread }.to_json
end
