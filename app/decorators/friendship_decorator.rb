class FriendshipDecorator < Draper::Decorator
  delegate_all

  def friendship_state
    model.state.titleize
  end

  def state_color_class
    case model.state
    when 'pending'
      "text-warning"
    when 'requested'
      "text-warning"
    when 'accepted'
      "text-success"
    when 'blocked'
      "text-danger"
    end
  end

  def sub_message
    case model.state
    when 'pending'
      "Friendship is pending, waiting for #{model.friend.name} to accept."
    when 'accepted'
      "You are friends with #{model.friend.name}."
    when 'requested'
      "Do you want to be friends with #{model.friend.name}?"
    end
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
