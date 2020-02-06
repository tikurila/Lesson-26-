	
#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end	

def seed_db db, barbers
	barbers.each do |barber| 	
		if !is_barber_exists? db, barber
		db.execute 'insert into barbers (name) values (?)', [barber]
	end
	end	
end

def get_db
	db = SQLite3::Database.new 'base.sqlite'
    db.results_as_hash = true
    return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "users" 
	( "Id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	 "Username"	TEXT,
	 "Phone"	TEXT,
	 "Datastamp"	TEXT,
	 "Barber"	TEXT,
	 "Color"	TEXT
   )'


	db.execute 'CREATE TABLE IF NOT EXISTS "barbers"
	 (	"Id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	    "name" TEXT
     )'

seed_db db, ['Dean Winchester', 'Sam Winchester', 'Castiel', 'Crowley', 'Jak']

db.close
end	


get '/' do
	erb "Hello!!!!!! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	
	erb :about
end	


get '/contacts' do
	erb :contacts
end	

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@data_time = params[:data_time]
	@barber = params[:barber]
	@color = params[:color]


  hh = {  :username => 'Введите имя',
  		  :phone => 'Введите телефон',
  		  :data_time => 'Введите дату и время' }

		@error = hh.select {|key,_| params[key] == ""}.values.join(",")

		if @error != ""
			return erb :visit
		end	


db = get_db
db.execute 'insert into 
users 
(username, phone, datastamp, barber, color)
 values ( ?, ?, ?, ?, ?)', [@username, @phone, @data_time, @barber, @color]
	
erb "Вы записаны! "
end	



get '/showusers' do
	@db = get_db
    @db.results_as_hash = true
    @vod = @db.execute 'SELECT * FROM Users ORDER BY id DESC '
    @db.close
	erb :showusers
end
