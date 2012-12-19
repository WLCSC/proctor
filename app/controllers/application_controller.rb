require 'fileutils'

class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :check_for_user

def sql_compare_symbol name
		{'>' => :gt, '>=' => :gte, '=' => :eq, '<=' => :lte, '<' => :lt}.index name.to_sym
	end

def ruby_compare_symbol name
		{'>' => :gt, '>=' => :gte, '==' => :eq, '<=' => :lte, '<' => :lt}.index name.to_sym
	end
  
  private
  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
	@current_user
  end

  def current_user
	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def check_for_user
    redirect_to root_path unless current_user
  end
  
  def check_for_admin
    redirect_to root_path unless current_user && current_user.admin?
  end

	def self_locked?
		File.exist?(Rails.root.join('.lockFile').to_s)
	end

	def self_lock
		FileUtils.touch Rails.root.join('.lockFile').to_s
	end

	def self_unlock
		File.delete Rails.root.join('.lockFile').to_s
	end
end
