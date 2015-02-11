require 'rails_helper'

feature "Listing statuses" do

  background do
    @user1 = create(:user)
    @user2 = create(:user)
    Status.create(content: "I like ice cream", user_id: @user1.id)
    Status.create(content: "Cats on the wall!", user_id: @user1.id)
    Status.create(content: "We went to a park", user_id: @user2.id)
  end

  scenario "requires login" do
    visit "/statuses"

    expect(page).to have_content("You need to log in or register before continuing.")
  end

  scenario "lists all statuses of all users" do
    log_in(@user1)
    visit "/statuses"

    expect(page).to have_content("I like ice cream")
    expect(page).to have_content("Cats on the wall!")
    expect(page).to have_content("We went to a park")
  end
end
