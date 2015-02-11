class UserNotifier < ApplicationMailer

  def friend_requested(friendship_id)
    friendship = Friendship.find(friendship_id)

    @user = friendship.user
    @friend = friendship.friend

    mail  to: @friend.email,
          subject: "#{@user.name} wants to be friends on Treebook"
  end

  def friend_request_accepted(friendship_id)
    friendship = Friendship.find(friendship_id)

    @user = friendship.user
    @friend = friendship.friend

    mail  to: @user.email,
          subject: "#{@friend.name} accepted your request on Treebook"
  end
end
