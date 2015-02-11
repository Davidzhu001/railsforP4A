require 'rails_helper'

feature "Creating friendship as user" do

  background do
    @user = create(:user)
    @user2 = create(:user)
    log_in(@user)
  end

  scenario "successfully creates a new friendship" do
    expect(Friendship.count).to eq(0)
    visit profiles_path(@user2)
    expect(page).to have_content("Add Friend")
    click_link "Add Friend"
    expect(page).to have_content("Are you sure you want to request this friend?")
    click_button "Yes, add friend"
    expect(page).to have_content("Friend request sent.")
    expect(Friendship.count).to eq(2)
  end

  scenario "creates a mutual friendship with requested state" do
    visit profiles_path(@user2)
    click_link "Add Friend"
    click_button "Yes, add friend"
    expect(page).to have_content("Friendship is pending")
    log_out(@user)
    log_in(@user2)
    visit friendships_path
    expect(page).to have_content("Friendship requested")
  end

end
