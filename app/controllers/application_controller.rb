require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "iprojs_top_super_secret"
  end

  get "/" do
    erb :welcome
  end

end
