require 'rails_helper'

feature "Editing statuses" do

  background do
    @user = create(:user)
    @admin = create(:admin)
    @status = Status.create(content: "I want to go home.", user_id: @user.id)
  end

  scenario "updates status with proper content as admin", :js => true do
    log_in(@admin)
    expect(Status.count).to eq(1)
    expect(@status.user_id).to eq(@user.id)
    visit statuses_path

    within dom_id_for(@status) do
      find('.status-options').click
      click_link 'Edit'
      find('.status-options').click
    end

    expect(page).to have_field('status_content', with: "I want to go home.")
    fill_in "status_content", with: "The boys are back in town."
    click_button "Submit"

    expect(page).to_not have_field('status_content')
    expect(page).to_not have_content("I want to go home.")
    expect(page).to have_content("The boys are back in town.")
  end

  scenario "updates status with proper content as user", :js => true do
    log_in(@user)
    expect(Status.count).to eq(1)
    expect(@status.user_id).to eq(@user.id)
    visit statuses_path

    within dom_id_for(@status) do
      find('.status-options').click
      click_link 'Edit'
      find('.status-options').click
    end

    expect(page).to have_field('status_content', with: "I want to go home.")
    fill_in "status_content", with: "The boys are back in town."
    click_button "Submit"

    expect(page).to_not have_field('status_content')
    expect(page).to_not have_content("I want to go home.")
    expect(page).to have_content("The boys are back in town.")
  end

  scenario "cancels update properly", :js => true do
    log_in(@user)
    within dom_id_for(@status) do
      find('.status-options').click
      click_link 'Edit'
      find('.status-options').click
    end

    expect(page).to have_field('status_content', with: "I want to go home.")
    fill_in "status_content", with: "The boys are back in town."
    expect(page).to have_field('status_content', with: "The boys are back in town.")
    click_link "Cancel"

    expect(page).to_not have_field('status_content')
    expect(page).to have_content("I want to go home.")
    expect(page).to_not have_content("The boys are back in town.")
  end

  scenario "displays error when status content is missing on update", :js => true do
    log_in(@user)
    within dom_id_for(@status) do
      find('.status-options').click
      click_link 'Edit'
      find('.status-options').click
    end

    expect(page).to have_field('status_content', with: "I want to go home.")
    fill_in "status_content", with: ""
    click_button "Submit"

    expect(page).to have_field('status_content')
    expect(page).to have_content(/can't be blank/i)
  end

  scenario "displays error when status content is shorter than 2 characters", :js => true do
    log_in(@user)
    within dom_id_for(@status) do
      find('.status-options').click
      click_link 'Edit'
      find('.status-options').click
    end

    expect(page).to have_field('status_content', with: "I want to go home.")
    fill_in "status_content", with: "S"
    click_button "Submit"

    expect(page).to have_field('status_content')
    expect(page).to have_content(/is too short/i)
  end
end
