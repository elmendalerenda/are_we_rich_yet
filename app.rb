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
    grant_date: Date.strptime(params['grantdate'], '%m-%d-%Y'),
    cliff_pct: 100.0,
    cliff_n_months: 1
  )
  spread = AWRY.spread(agreement, 30.0, Date.today)

  { spread: spread }.to_json
end
