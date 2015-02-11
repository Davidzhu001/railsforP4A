require 'rails_helper'

describe FriendshipDecorator do
  describe "#friendship_state" do
    context "with a pending friendship" do
      before do
        @friend = create(:user)
        @friendship = create(:pending_friendship, friend: @friend)
        @decorator = FriendshipDecorator.decorate(@friendship)
      end

      it "returns Pending" do
        expect(@decorator.friendship_state).to eq("Pending")
      end
    end

    context "with a requested friendship" do
      before do
        @friend = create(:user)
        @friendship = create(:requested_friendship, friend: @friend)
        @decorator = FriendshipDecorator.decorate(@friendship)
      end

      it "returns Pending" do
        expect(@decorator.friendship_state).to eq("Requested")
      end
    end

    context "with an accepted friendship" do
      before do
        @friend = create(:user)
        @friendship = create(:accepted_friendship, friend: @friend)
        @decorator = FriendshipDecorator.decorate(@friendship)
      end

      it "returns Pending" do
        expect(@decorator.friendship_state).to eq("Accepted")
      end
    end
  end

  describe "#sub_message" do
    context "with a pending friendship" do
      before do
        @friend = create(:user)
        @friendship = create(:pending_friendship, friend: @friend)
        @decorator = FriendshipDecorator.decorate(@friendship)
      end

      it "returns the proper message" do
        expect(@decorator.sub_message).to eq("Friendship is pending, waiting for #{@friend.name} to accept.")
      end
    end

    context "with a requested friendship" do
      before do
        @friend = create(:user)
        @friendship = create(:requested_friendship, friend: @friend)
        @decorator = FriendshipDecorator.decorate(@friendship)
      end

      it "returns the proper message" do
        expect(@decorator.sub_message).to eq("Do you want to be friends with #{@friend.name}?")
      end
    end

    context "with an accepted friendship" do
      before do
        @friend = create(:user)
        @friendship = create(:accepted_friendship, friend: @friend)
        @decorator = FriendshipDecorator.decorate(@friendship)
      end

      it "returns the proper message" do
        expect(@decorator.sub_message).to eq("You are friends with #{@friend.name}.")
      end
    end
  end
end
