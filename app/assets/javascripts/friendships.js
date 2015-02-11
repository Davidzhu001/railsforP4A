window.userFriendships = [];

var friendshipsReady;

friendshipsReady = function() {

  $.ajax({
    url: Routes.friendships_path({format: 'json'}),
    dataType: 'json',
    type: 'GET',
    success: function(data) {
      window.userFriendships = data;
    }
  });

  $('#add-friendship').click(function(event) {
    event.preventDefault();
    var addFriendshipBtn = $(this);
    $.ajax({
      url: Routes.friendships_path({friendship: { friend_id: addFriendshipBtn.data('friendId')}}),
      dataType: 'json',
      type: 'POST',
      success: function(e) {
        addFriendshipBtn.hide();
        $('#friending').html("<span class='btn btn-success'>Friendship Requested</span>");
      }
    });
  });

};

$(document).ready(friendshipsReady);
$(document).on('page:load', friendshipsReady);
