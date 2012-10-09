require 'auth.rb'

class SessionsController < ApplicationController
	skip_before_filter :check_for_user, :only => ['new', 'create']
	def new
	end

	def create
		user = User.where(:username => params[:username]).first
		if user
			lgi = ldap_login(params[:username], params[:password])
			if lgi && lgi.length > 0
				user = User.find_by_username(params[:username])
				user = ldap_populate(params[:username], params[:password], user)
				session[:user_id] = user.id
				flash[:notice] = "Logged in!"
				redirect_to '/'
			else
				flash[:alert] = "Invalid login."
				redirect_to '/sessions/new'
			end
		else
				flash[:alert] = "You are not allowed to log in."
				redirect_to '/'
		end
	end

	def destroy
		session[:user_id] = nil  
		redirect_to root_url, :notice => "Logged out!"  
	end
end
