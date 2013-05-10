#encoding:utf-8
require 'spec_helper'

describe Relationship do
  let(:follower) { FactoryGirl.create(:user)}
  let(:followed) { FactoryGirl.create(:user)}
  let(:relationship) { follower.relationships.build(followed_id: followed.id)}

  subject { relationship }
  it { should be_valid }

  describe "可访问属性" do
    it "应该不允许存取关注者的ID" do
      expect do
        Relationship.new(follower_id: follower.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "关注者方法" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should == follower }
    its(:followed) { should == followed }
  end

  describe "当被关注者的用户ID不存在或为空时" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end

  describe "当关注者的用户ID不存在或是为空时" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
end
