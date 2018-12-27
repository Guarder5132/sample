require 'spec_helper'

describe "User Pages" do

  subject { page }

  #用户列表页面的测试
  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
  
    it "should list each user" do
      User.all.each do |user|
      expect(page).to have_selector('li', text: user.name)
      end
    end
    #测试删除用户功能
    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
      
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  #Users控制器的测试代码，包含“注册”页面的测试用例
  describe "signup page" do
    before {visit signup_path}

    it {should have_content('Sign up')}
    it {should have_title(full_title('Sign up'))}
  end

  #测试用户注册功能的代码
  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
   end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }  #验证刚注册的用户是否会自动登陆
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  #用户编辑页面的测试
  describe "edit" do
    let(:user) {FactoryGirl.create(:user)}
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it {should have_content ("Update your profile")}
      it {should have_title("Edit user")}
      it {should have_link('change', href:'http://gravatar.com/emails')}
    end

    describe "with invalid information" do
      before {click_button "Save changes"}

      it {should have_content ('error')}
    end

    describe "with valid information" do
      let(:new_name)  {"New Name"}
      let(:new_email) {"new@example.com"}
      before do
        fill_in "Name",             with:new_name
        fill_in "Email",            with:new_email
        fill_in "Password",         with:user.password
        fill_in "Confirm Password", with:user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path)}
      #新方法reload， 使用user.reload 从测试数据库中重新加载user的数据，
      #然后检测用户的名字和Email地址是否更新成了新的值
      specify {expect(user.reload.name).to  eq new_name}
      specify {expect(user.reload.email).to eq new_email}
    end
  end
end
