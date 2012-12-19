task :initialize => :environment do
	if APP_CONFIG[:auth_local]
		User.create :username => 'admin', :password => 'password', :email_address => 'proctor@mailinator.com', :name => 'Administrator'
		puts "Log in as admin/password"
	else
		puts "Please enable local authentication in config/app_config.yml"
	end
end
