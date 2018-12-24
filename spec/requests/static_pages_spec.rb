require 'spec_helper'

describe "Static Pages" do

  subject { page }

  #测试主页面
  describe "Home page" do
    before { visit root_path }
    it { should have_content('Sample App') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
  end
  

  #测试帮助页面
  describe "Help page" do
    before {visit help_path}
    it {should have_content('Help')}
    it {should have_title(full_title('Help'))}
  end

  #测试关于页面
  describe "About page" do
    before {visit about_path}
    it {should have_content('About Us')}
    it {should have_title(full_title('About Us'))}
  end

  #联系页面的测试
  describe "Contact page" do
    before {visit contact_path}
    it {should have_content('Contact')}
    it {should have_title(full_title('Contact'))}
  end
end
