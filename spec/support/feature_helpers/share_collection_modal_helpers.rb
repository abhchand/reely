module FeatureHelpers
  module ShareCollectionModalHelpers
    def click_toggle
      within(".share-collection__link-sharing") do
        page.find(".switch").click
        wait_for_ajax
      end
    end

    def expect_link_sharing_enabled_for(collection)
      # Frontend
      within(".share-collection__link-sharing") do
        switch = page.find(".switch")
        expect(switch["class"].split(" ")).to include("on")
        expect(page).to have_selector(".share-collection__link-sharing-content")
      end

      # Backend
      collection.reload
      expect(collection.sharing_config["link_sharing_enabled"]).to eq(true)
    end

    def expect_link_sharing_disabled_for(collection)
      # Frontend
      within(".share-collection__link-sharing") do
        switch = page.find(".switch")
        expect(switch["class"].split(" ")).to_not include("on")
        expect(page).
          to_not have_selector(".share-collection__link-sharing-content")
      end

      # Backend
      collection.reload
      expect(
        collection.sharing_config["link_sharing_enabled"] || false
      ).to eq(false)
    end

    def click_share_modal_close
      within(".collections-share-modal") do
        page.find(".modal-content__button--close").click
      end
    end

    def displayed_sharing_url
      page.find(".share-collection__url").value
    end

    def link_sharing_url_for(collection)
      Rails.application.routes.url_helpers.collections_sharing_display_url(
        id: collection.share_id
      )
    end
  end
end
