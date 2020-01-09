require 'sqlite3'

db = SQLite3::Database.new 'base.sqlite'

db.results_as_hash = true

db.execute "SELECT * FROM Users ORDER BY id DESC" do |row|

	print row['Username']
	print "\t-\t"
	puts row['Datastamp']
	puts "======================"
end	


db.close

