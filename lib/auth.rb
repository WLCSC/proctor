require 'simple_ldap_authenticator.rb'

SimpleLdapAuthenticator.servers = [APP_CONFIG[:ldap_domain_controller]]
SimpleLdapAuthenticator.logger = Rails.logger
SimpleLdapAuthenticator.use_ssl = true

def ldap_login user,pass
	#r = Logger.new('auth.txt')
	#r.info("Testing user #{user}")
	if l = SimpleLdapAuthenticator.valid?(user,pass)
		#r.info("Validated user #{user}")
		l
	else
		#r.info("Denied user #{user}")
		#raise "Denied!"
		false
	end
end

def ldap_populate user, pass, obj=nil
	if l = SimpleLdapAuthenticator.valid?(user,pass)[0]
		u = obj || User.new
		u.username = user
		u.name = l['givenname'][0].to_s + " " + l['sn'][0].to_s
		u.administrator = true if(l[:memberof].include? APP_CONFIG[:ldap_domain_administrator_ou])
		u.save
		u
	else
		false
	end
end

def ldap_search user
	if l = SimpleLdapAuthenticator.search(user)
		l
	else
		nil
	end
end
