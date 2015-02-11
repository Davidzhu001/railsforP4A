module StatusHelpers

  module Feature

    def create_status(options={})
      options[:content] ||= "My day was great"

      visit statuses_path
      expect(page).to have_content("New Status")
      click_link "New Status"
      expect(page).to have_content("Submit")
      expect(page).to have_content("Cancel")

      fill_in "Content", with: options[:content]
      click_button "Submit"
    end

    def dom_id_for(model)
      ["#", ActionView::RecordIdentifier.dom_id(model)].join
    end

  end

end
