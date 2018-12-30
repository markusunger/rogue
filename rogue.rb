require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'pry-remote'

require_relative 'lib/game_engine'

configure do
  set :engine, GameEngine.new
end

get '/' do  # general rendering of the UI
  @state = settings.engine.draw
  # binding.remote_pry
  erb :game
end

get '/act/:position' do  # handle player movement/attack
  settings.engine.request('act_player', params['position'])
  settings.engine.process_turn
  redirect to('/')
end

get '/skill/:slot' do # handle skill usage
  settings.engine.request('handle_skill', params['slot'])
  settings.engine.process_queue
  redirect to('/')
end

get '/skillreset' do # resets markers and active player skill
  settings.engine.request('reset_active_skill')
  settings.engine.process_queue
  redirect to('/')
end
