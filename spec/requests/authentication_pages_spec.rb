#encoding:utf-8
require 'spec_helper'

describe "authentication" do
  subject { page }

  describe "Signin" do
    before { visit signin_path}
    
    describe "with invalid information" do
      before { click_button "登录"}
        
      it { should have_selector('h1', text: "登录")}
      it { should have_selector('div.alert.alert-error', text: '无效')}

      describe "after visiting another page" do
        before { click_link "主页"}
        it { should_not have_selector('div.alert.alert-error')}
      end
    end

    describe "with valid information" do
      let(:user){ FactoryGirl.create(:user)}
      
      before { sign_in user }
      
      it { should have_selector('title', text: user.name)}
      it { should have_selector('title', text: user.name)}
      it { should have_link('个人信息', href: user_path(user))}
      it { should have_link('设置', href: edit_user_path(user))}
      it { should have_link('退出', href: signout_path)}
      it { should_not have_link('登录', href: signin_path)}

      describe "followed by signout" do
        before { click_link "退出" }

        it { should have_link('登录')}
      end
    end
  end

  describe "authorization" do
    
    describe "non-signed_in users" do
      let(:user) { FactoryGirl.create(:user)}

      describe "when attempting to visit a protected page" do
        before do 
          visit edit_user_path(user)
          fill_in "邮箱", with: user.email
          fill_in "密码", with: user.password
          click_button "登录"
        end
      
      describe "after signing in " do
        it "should render the desired protected page" do
          page.should have_selector('title',text: "编辑")
        end
      end
    end

      describe "in the Users controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          
          it { should have_selector('title', text: "登录")}
        end

        describe "submitting to the update action" do
          before { put user_path(user)}

          specify { response.should redirect_to(signin_path)}
        end

        describe "visitting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: "登录")}
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com")}

      before { sign_in user }

      describe "visiting User#edit page " do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('编辑'))}
      end

      describe "submitting a PUT request to the User#update action" do
        before { put user_path(wrong_user)}
        specify { response.should redirect_to(root_path)}
      end
    end

    describe "不是管理元的用户" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user)}
      before { sign_in non_admin }

      describe "点击按钮提交到用户控制器中请求删除行为" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path)}
      end
    end
  end
end

