require 'rails_helper'

feature "Deleting friendship" do

  background do
    @user = create(:user)
    @user2 = create(:user)
    Friendship.request(@user, @user2)
    @friendship = Friendship.where(user_id: @user.id).first
    log_in(@user)
  end

  scenario "successfully deletes a friendship and a mutual object" do
    visit edit_friendship_path(@friendship)
    click_button "Cancel friendship"
    expect(page).to have_content("You are no longer friends.")
    expect(page).to have_content("There are no friendships to view! Don't be shy, add some friends :)")
    log_out(@user)
    log_in(@user2)
    visit friendships_path
    expect(page).to have_content("There are no friendships to view! Don't be shy, add some friends :)")
  end
end
