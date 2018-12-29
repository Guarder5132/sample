require 'spec_helper'

describe User do

  before do 
    @user = User.new(name: "Example User", 
                            email: "user@example.com",
                            password:"foobar",
                            password_confirmation:"foobar")
  end

  subject { @user }

  #pending "add some examples to (or delete) #{__FILE__}"

  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token)}
  it {should respond_to(:authenticate) }
  it {should respond_to(:admin)}
  #测试用户对象是否可以响应microposts 方法
  it {should respond_to(:microposts)}
  it {should respond_to(:feed)}
  #验证name属性的失败测试
  it { should be_valid }
  it { should_not be_admin }

  #测试admin属性
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end


  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  #对email属性存在的测试
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  #对名字长度的测试
  describe "when name is too long" do
    before {@user.name = "a"*51}
    it {should_not be_valid}
  end

  #对Email格式验证的测试
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                  foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  #拒绝相同Email地址的测试,不区分大小写。
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it {should_not be_valid}
  end

  #验证密码存在性的测试
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                      password: " ", password_confirmation: " ")
    end
    it{should_not be_valid}
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  #密码长度测试 ，大于6才能通过
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  #测试密码是否正确
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
    
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  #把Email地址转换成小写字母测试
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  #测试合法的(非空)记忆权标值
  describe "remember token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
  end

  #测试用户微博的次序
  describe "micropost associations" do

    before {@user.save}
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right micropost in the right order" do
      #表明所创建的微博应该按照创建时间倒序排列，最新创建的微博排在最前面
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    #测试用户删除后，所发布的微博是否也被删除了
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) {should include(newer_micropost)}
      its(:feed) {should include(older_micropost)}
      its(:feed) {should_not include(unfollowed_post)}
    end
  end
end
