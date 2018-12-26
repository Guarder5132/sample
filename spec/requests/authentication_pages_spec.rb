require 'spec_helper'

describe "Authentication" do
  
  subject {page}

  #对new动作和对应视图的测试
  describe "signin page" do
    before {visit signin_path}

    it {should have_content('Sign in')}
    it {should have_title('Sign in')}
  end

  
  describe "signin" do

    before {visit signin_path}
    #登陆失败时测试
    describe "with invalid information" do
      before {click_button "Sign in"}

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before {click_link "Home"}
        it {should_not have_selector('div.alert.alert-error')}
      end
    end

    #登陆成功时测试
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      #测试用户退出
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end
end
