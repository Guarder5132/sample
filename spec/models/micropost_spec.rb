require 'spec_helper'

#Micropost模型测试 
describe Micropost do
  
  let(:user) {FactoryGirl.create(:user)}
  before {@micropost = user.microposts.build(content: "Lorem ipsum")}

  
  subject {@micropost}

  it {should respond_to(:content)}
  it {should respond_to(:user_id)}
  #测试微博和用户之间的关联
  it {should respond_to(:user)}
  its(:user) {should eq user}

  it {should be_valid}

  #测试微博能否通过验证
  describe "when user_id is not present" do
    before {@micropost.user_id = nil}
    it {should_not be_valid}
  end

  describe "with blank content" do
    before {@micropost.content = " "}
    it {should_not be_valid}
  end

  describe "with content that is too long" do
    before {@micropost.content = "a" * 141}
    it {should_not be_valid}
  end
end
