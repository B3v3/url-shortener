require 'rails_helper'

describe "the url creating process", type: :feature do
  let(:url) {build(:url)}
  
  it "create a shortened url" do
    visit '/url/new'
    within("#new_url") do
      fill_in 'url_link', with: 'google.com'
      fill_in 'url_shortening', with: 'kapibary'
    end
    click_button 'Submit'
    expect(page).to have_content 'Your url for link is: https://b3v3-url-shortener.herokuapp.com/url/kapibary'
  end

  it "show errors" do
    visit '/url/new'
    within("#new_url") do
      fill_in 'url_link', with: ''
      fill_in 'url_shortening', with: 'dajcie_mi_prace'
    end
    click_button 'Submit'
    expect(page).to have_content "Link can't be blank"
  end
end
