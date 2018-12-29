module SessionsHelper

    #首先，创建新权标；  随后，把未加密的权标存入浏览器的cookie；
    #然后，把加密后的权标存入数据库； 最后，把制定的用户设为当前登陆的用户。
    def sign_in(user)
        remember_token = User.new_remember_token
        cookies.permanent[:remember_token] = remember_token
        #update_attribute方法是保存记忆权标的
        user.update_attribute(:remember_token, User.encrypt(remember_token))
        self.current_user = user
    end

    def signed_in?
        !current_user.nil?
    end

    #这段代码定义的current_user=方法是用来处理current_user赋值操作的
    def current_user=(user)
        @current_user = user
    end

    def current_user
        remember_token = User.encrypt(cookies[:remember_token])

        #1. ||=(or equals)操作符，使用这个后，当且@current_user未定义时才
        #会把通过记忆权标获取的用户赋值给实例变量@current_user。
        #2. 第一次调用current_user方法时调用find_by方法，后续在调用的话直接
        #返回@current_user的值，而不必在查询数据库。
        @current_user ||= User.find_by(remember_token: remember_token)
    end   

    def current_user? (user)
        user == current_user
    end
    
    def signed_in_user
        unless signed_in?
            store_location
            redirect_to signin_url, notice: "Please sign in."
        end
    end

    #Sessions 帮助方法模块中定义的gign_out 方法
    def sign_out
        self.current_user = nil
        cookies.delete(:remember_token)
    end

    def redirect_back_or(default)
        redirect_to(session[:return_to] || default)
        session.delete(:return_to)
    end

    def store_location
        session[:return_to] = request.fullpath
    end
end
