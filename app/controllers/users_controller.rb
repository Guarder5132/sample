class UsersController < ApplicationController
  #1.使用before_action 方法实现权限限制，这个方法会在指定的动作执行前
  #先运行指定的方法。  
  #2.为了实现用户先登陆的限制，我们要定义一个名为 signed_in_user的方法
  #然后调用before_action ：signed_in_user
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end
  
  def show
    #定义@user变量，调用find方法提取数据库里用户信息
    #params是获取ID信息，find方法是获取这个ID的所有信息
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    #@user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id])
    #健壮参数
    if @user.update_attributes(user_params)
      flash[:success]= "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private 

    #需要params Hash包含：user元素，而且只允许传入name，email，
    #password，password_confirmation属性
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    #Before filters

    # def signed_in_user
    #   unless signed_in?
    #     store_location
    #     redirect_to signin_url, notice: "Please sign in"
    #   end
    # end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)  
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
