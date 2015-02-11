module AuthenticationHelpers

  module Feature

    def log_in(user)
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button 'Log in'
      within ".navbar" do
        expect(page).to have_content(user.name)
      end
    end

    def log_out(user)
      visit statuses_path
      click_link "#{user.name}"
      click_link 'Log Out'
      within ".navbar" do
        expect(page).to_not have_content(user.name)
      end
    end

    def register_user
      visit "/"
      within ".navbar" do
        expect(page).to have_content("Register")
        click_link "Register"
      end

      fill_in "Name", with: "John"
      fill_in "Email", with: "jasmine@mail.com"
      fill_in "Password", with: "treebook666"
      fill_in "Confirm password", with: "treebook666"

      click_button "Register"
    end

  end

end
