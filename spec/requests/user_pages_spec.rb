#encoding:utf-8
require 'spec_helper'

describe "User Pages" do
  subject { page }
  
  describe "profile page" do
    let(:user){ FactoryGirl.create(:user)}
    before { visit user_path(user) }
    it { should have_selector('h1', text: user.name)}
    it { should have_selector('title', text: user.name)}
  end

  describe "signup page" do 
    before { visit signup_path }

    it { should have_selector('h1', text: '注册') }
    it { should have_selector('title', text:'Sign up')}
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit){"提交"}

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "用户名",         with: "Example User"
        fill_in "邮箱",        with: "user@example.com"
        fill_in "密码",     with: 123456
        fill_in "重复密码", with: 123456
      end  
        it "should create a user" do
            expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end

