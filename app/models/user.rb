class User < ActiveRecord::Base
    before_save {self.email = email.downcase}
    before_create :create_remember_token
    # has_secure_password
    # before_save { email.downcase! }
    validates :name,  presence:true, length: {maximum:50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    validates :email, presence:true, 
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness:{ case_sensitive:false}
    has_secure_password
    validates :password, length: { minimum: 6 }

    def User.new_remember_token
        SecureRandom.urlsafe_base64
    end

    def User.encrypt(token)
        #调用to_s是为了处理输入为nil的情况
        Digest::SHA1.hexdigest(token.to_s)
    end

    private

     def create_remember_token
        #如果不指定self，我们就只创建一个名为remember_token的局部变量而已
        #加上self后，赋值操作就会把值赋值给用户的remember_token属性，保存用户时，
        #随着其他的属性一起存入数据库
        self.remember_token = User.encrypt(User.new_remember_token)
     end
end
