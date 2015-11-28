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

def is_time_free? booking
	time=Client.where(barber: booking.barber, datestamp: booking.datestamp)
	time.length > 0
end

before do
	@barbers=Barber.all
	@clients=Client.order('created_at DESC')
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
	a=@booking.barber
	b=@booking.datestamp
	if is_time_free? @booking 
		@error='Sorry! This time alredy busy'
	else
		if @booking.save
			@answer='We are waiting you'
		else
			@error=@booking.errors.full_messages.first
		end
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
		@error=@contacts.errors.full_messages.first
	end
  	erb :contacts
end

get '/admin' do
	erb :admin
end

get '/barber/:id' do
	@barber=Barber.find(params[:id])
	@BarberClients=Client.where(barber: @barber.name)
	erb :barber
end