require 'spec_helper'

describe "Static Pages" do
  #包含了一个describe块以及其中一个测试用例（sample） 。
  #以it “，，，” do 开头的代码块就是一个用例。
  describe "Home page" do
      #指明我们描绘的是首页，内容是一个字符串。
    it "should have the content 'Sample App'" do
      #如果访问的地址是'/static_pages/home'时，内容应该包含'Sample App'这两个词。
      #使用了Capybara中的visit函数来模拟浏览器中的访问操作。
      visit '/static_pages/home'
      #使用page变量来测试页面中是否包含正确内容
      expect(page).to have_content('Sample App')
    end
      #主界面标题的测试
    it "should have the right title 'Home" do
      visit '/static_pages/home'
      # have_title方法来测试一个HTML页面标题中是否含有制定内容（"Ruby on Rails Tutorial Sample App | Home"）
      expect(page).to have_title("Ruby on Rails Tutorial Sample App | Home")
    end
  end

  #测试帮助页面
  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the right title 'Help" do
      visit '/static_pages/help'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App | Help")
    end
  end

  #测试关于页面
  describe "About page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end
    it "should have the right title 'About Us" do
      visit '/static_pages/about'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App | About Us")
    end
  end
end
