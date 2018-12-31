require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'pry-remote'

require_relative 'lib/game_engine'

configure do
  set :engine, GameEngine.new
end

get '/' do  # general rendering of the UI
  
  # binding.remote_pry
  if settings.engine.has_won
    @state = settings.engine.last_round
    settings.engine.has_won = false
    erb :stats
  elsif settings.engine.has_lost
    @state = settings.engine.last_round
    settings.engine.has_lost = false
    erb :stats
  else
    @state = settings.engine.draw
    erb :game
  end
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
