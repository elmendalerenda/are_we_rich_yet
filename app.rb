require 'sinatra'
require 'json'

get '/' do
  erb :index
end

post '/spread' do
  { spread: '5000' }.to_json
end
