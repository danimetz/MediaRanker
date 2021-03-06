class UsersController < ApplicationController



  def index
    @users = User.all.order(:username)
  end

  def new
    @user = User.new
  end

  def login
    user = User.find_by(username: params[:user][:username])

    if user.nil?
      user = User.create(username: params[:user][:username])
      session[:user_id] = user.id
      flash[:success] = "Successfully created new user #{ user.username } with ID #{user.id}"
      redirect_to root_path
    else
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in as existing user #{ user.username }"
      redirect_to root_path
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def show
    id = params[:id]
    @user = User.find_by(id: id)


    if @user.nil?
      render :notfound, status: :not_found
    end

    @votes = @user.votes
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Successfully logged out'
    redirect_back fallback_location: root_path
  end

  private

  def user_params
    return params.require(:user).permit(:username)
  end
end
