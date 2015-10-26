require 'sinatra'
require 'json'
require './lib/eso_exercise_simulator'
require './lib/options_agreement'

get '/' do
  erb :index
end

post '/spread' do
  agreement = build_agreement
  spread = AWRY::ESOExerciseSimulator.spread(agreement, market_price, Date.today)

  { spread: spread }.to_json
end

private

def form_params
  @param ||= JSON.parse(request.body.read)
end

def market_price
  form_params['market_price'].to_f
end

def agreement_params
  form_params['agreements']
end

def build_agreement
  params = agreement_params.first
  AWRY::OptionsAgreement.new(
    stock: (params['stocks']).to_f,
    strike_price: (params['strikeprice']).to_f,
    grant_date: Date.parse(params['grantdate']),
    cliff_pct: params['cliff_pct'].to_f,
    cliff_n_months: params['cliff_n_months'].to_f,
    vesting_period: params['vesting_period'].to_f
  )
end
