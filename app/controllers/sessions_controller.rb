require 'auth.rb'

class SessionsController < ApplicationController
	skip_before_filter :check_for_user, :only => ['new', 'create']
	def new
	end

	def create
		lgi = ldap_login(params[:username], params[:password])
		if lgi && lgi.length > 0
			user = User.find_by_username(params[:username])
			user = ldap_populate(params[:username], params[:password], user)
			session[:user_id] = user.id
			flash[:notice] = "Logged in!"
		else
			flash[:alert] = "Invalid login."
			redirect_to '/sessions/new'
		end
	end

	def destroy
		session[:user_id] = nil  
		redirect_to root_url, :notice => "Logged out!"  
	end
end
