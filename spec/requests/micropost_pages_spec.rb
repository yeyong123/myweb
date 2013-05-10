require 'spec_helper'

describe "MicropostPages" do
  
  subject { page }
  
  let(:user){ FactoryGirl.create(:user)}
  before { sign_in user }

  describe "微博创建" do
    before { visit root_path }

    describe "要是无效的信息" do
      
      it "不应创建微博" do
        expect { click_button "发布"}.not_to change(Micropost, :count)
      end

    describe "弹出错误信息" do
      before { click_button "发布"}
      
      it { should have_content('error')}
    end
  end

    describe "要是有效的消息" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      
      it "应该创建一篇微博" do
        expect { click_button "发布"}.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "微博删除" do
    before { FactoryGirl.create(:micropost, user: user )}

    describe "是当前授权的用户" do
      before { visit root_path }
      
      it "应该删除一篇微博" do
        expect { click_link "删除"}.to change(Micropost, :count).by(-1)
      end
    end
  end
end
