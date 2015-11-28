#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
	validates :name, presence: true, length: { minimum: 3 }
    validates :phone, presence: true
    validates :barber, presence: true
    validates :datestamp, presence: true
    validates :color, presence: true  
end

class Barber < ActiveRecord::Base
end

before do
	@barbers=Barber.all
end

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

get '/' do
	 
	erb :index
end

get '/visit' do
  erb :visit
end

post '/visit' do
	
	@booking = Client.new params[:client]
	if @booking.valid?
		@booking.save
		@answer='We are waiting you'
	end
  erb :visit
end

get '/about' do
  erb :about
end

get '/contacts' do
  erb :contacts
end