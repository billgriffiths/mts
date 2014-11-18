class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(user_params)

      if @user.save
        redirect_to @user, notice: 'User was successfully created.'
      else
        render :new 
      end
    end

  # PATCH/PUT /users/1
  def update
    @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render :edit 
      end
    end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.' 
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :user_name, :password, :role, :password_confirmation)
    end
    
    def add
      @user = User.new(params[:user])
      if request.post? and @user.save
        flash.now[:notice] = "User #{@user.user_name} created"
      end
    end

    def list_user
      @users = User.find(:all, :order => 'last_name')
  #    @user_pages, @users = paginate :users, :per_page => 10
    end

    def show_user
      @user = User.find(params[:id])
    end

    def create_user
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = 'User was successfully created.'
        redirect_to :action => 'list_users'
      else
        render :action => 'new_user'
      end
    end

    def edit_user
      @user = User.find(params[:id])
    end

    def update_user
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        redirect_to :action => 'show_user', :id => @user
      else
        render :action => 'list_user'
      end
    end

    def destroy_user
      User.find(params[:id]).destroy
      redirect_to :action => 'list_users'
    end

end
