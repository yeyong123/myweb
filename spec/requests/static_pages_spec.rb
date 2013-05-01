require 'spec_helper'

describe "Static pages" do
  describe "Home page" do
    it "should have the content 'My Web'" do
      visit '/static_pages/home'
      page.should have_content('My Web')
    end
  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end
  end

  describe "About Us" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_content('About Us')
    end
  end

  describe "Contact" do
    it "should have the content 'Contact'" do
      visit '/static_pages/contact'
      page.should have_content('Contact')
    end
  end
end
