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

class Contact <ActiveRecord::Base
	validates :name, presence: true
    validates :email, presence: true
    validates :text, presence: true
end

before do
	@barbers=Barber.all
	@clients=Client.all
	@contacts=Contact.all
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
	@booking=Client.new
	erb :visit
end

post '/visit' do
	@booking = Client.new params[:client]
	if @booking.save
		@answer='We are waiting you'
	else
		@error='Please, give us full information'
	end
  erb :visit
end

get '/about' do
  erb :about
end

get '/contacts' do
	@contacts = Contact.new
	erb :contacts
end

post '/contacts' do
	@contacts = Contact.new params[:user]
	if @contacts.save
		@answer='Your message send'
	else
		@error='Please fill out all form'
	end
  	erb :contacts
end

get '/admin' do
	erb :admin
end