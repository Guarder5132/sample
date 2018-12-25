require 'spec_helper'

describe "Static Pages" do

  subject { page }
  
  shared_examples_for "all static pages" do
    it {should have_content(heading)}
    it {should have_title(full_title(page_title))}
  end

  #测试主页面
  describe "Home page" do
    before { visit root_path }
    let(:heading)     {'Sample App'}
    let(:page_title)  {''}

    it_should_behave_like "all static pages"
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

  #测试布局中的连接
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
  end
end
