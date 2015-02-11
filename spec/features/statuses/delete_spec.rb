require 'rails_helper'

feature "Deleting statuses" do

  background do
    @user = create(:user)
    @user2 = create(:user)
    @admin = create(:admin)
    @status = Status.create(content: "I want to go home.", user_id: @user.id)
    @status2 = Status.create(content: "Who ate my cheese?", user_id: @user2.id)
  end

  scenario "successfully deletes the status as owner", :js => true do
    log_in(@user)
    expect(@status.user_id).to eq(@user.id)
    expect(@status2.user_id).to eq(@user2.id)
    visit statuses_path

    expect(page).to have_content("I want to go home.")
    expect(page).to have_content("Who ate my cheese?")

    within dom_id_for(@status) do
      find('.status-options').click
      expect(page).to have_content('Delete')
      click_link 'Delete'
    end

    expect(page).to_not have_content("I want to go home.")
    expect(page).to have_content("Who ate my cheese?")
  end

  scenario "successfully deletes statuses as admin", :js => true do
    log_in(@admin)
    expect(@status.user_id).to eq(@user.id)
    expect(@status2.user_id).to eq(@user2.id)
    visit statuses_path

    expect(page).to have_content("I want to go home.")
    expect(page).to have_content("Who ate my cheese?")

    within dom_id_for(@status) do
      find('.status-options').click
      expect(page).to have_content('Delete')
      click_link 'Delete'
    end

    within dom_id_for(@status2) do
      find('.status-options').click
      expect(page).to have_content('Delete')
      click_link 'Delete'
    end

    expect(page).to_not have_content("I want to go home.")
    expect(page).to_not have_content("Who ate my cheese?")
  end

end
