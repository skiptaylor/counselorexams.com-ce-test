configure :development do
	DataMapper::Logger.new $stdout, :debug
	# DataMapper.setup :default, 'postgres://localhost:5432/ce-exams-db'
  DataMapper.setup :default, 'postgres://localhost:5432/ce_emails_db'
end

configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
end