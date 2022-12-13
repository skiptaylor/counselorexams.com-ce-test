configure :development do
	DataMapper::Logger.new $stdout, :debug
	DataMapper.setup :default, 'postgres://localhost:5432/ce-exams-db'
end

configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
end