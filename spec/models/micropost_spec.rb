require 'spec_helper'

describe Micropost do
  let(:user){ FactoryGirl.create(:user)}
  
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }
 
  subject { @micropost }

  it { should respond_to(:content)}
  it { should respond_to(:user_id)}
  it { should respond_to(:user)}
  its(:user) { should == user }
  
  it { should be_valid }

  describe "当用户ID不存在" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "取得读写属性" do
    it "应该不需要取得用户ID" do
      expect do
        Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "为空的内容" do
    before { @micropost.content = " "}
    it { should_not be_valid }
  end

  describe "内容太长了" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end
