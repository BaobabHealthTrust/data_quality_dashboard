class UserController < ApplicationController
  def index
  end

  def login
    render :layout => false
  end

  def logout
    session[:user_id] = nil
    User.current = nil
    redirect_to :controller => :home
  end

  def create
    @message = params[:message]
    @status = params[:success]
  end

  def edit
    @user = User.all
  end

  def edit_user
      @user = User.where(:username => params[:user_name]).first
  end

  def delete
    user = User.find(params[:user_id])
    user.update_attributes(:voided => true)
    render :text =>  "User successfully voided!" and return
  end

  def verify_user

    state = User.authenticate(params[:username],params[:password])

    if state
      user = User.find_by_username(params[:username])
      session[:user_id] = user.id
      User.current = user
      redirect_to :controller => :home
    end
  end

  def save
    results = User.create_user(params[:username], params[:password],params[:user_role])
    redirect_to :action => "create", :message => results.first, :success => results.last
  end

  def save_edit
    User.update_user(params[:user_name_old],params[:username],params[:password],params[:user_role])
    redirect_to :action => "edit"
  end
end
