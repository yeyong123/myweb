require 'spec_helper'
describe "Static pages" do
  subject {page}
  
  describe "Home page" do

    before {visit root_path }

    it { should have_selector('h1', text: 'Twitter?') }
    it { should have_selector('title', text: full_title('') )}
    it { should_not  have_selector 'title', text: '| 主页'}
  end

  describe "About Us" do
    before { visit about_path }

    it { should have_selector('h1', text: 'About Us')}
    it { should have_selector('title', text: full_title('About Us'))}
  end

  describe "Contact" do
    before { visit contact_path }
    it { should have_selector('h1', text: 'Contact')}
    it { should have_selector('title', text: full_title('Contact'))}
  end

  describe "Help" do
    before { visit help_path }
    it { should have_selector('h1', text: 'Help')}
    it { should have_selector('title', text: full_title('Help'))}
  end

  describe "登录用户的结果" do
    let(:user) { FactoryGirl.create(:user)}
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
      FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet" )
      sign_in user
      visit root_path
    end
  
    it "应该渲染发布的这个用户" do
      user.feed.each do |item|
        page.should have_selector("li##{item.id}", text: item.content )
      end
    end
  end
end

