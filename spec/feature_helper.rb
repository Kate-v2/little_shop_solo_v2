
module FeatureHelper

  def login(user)
    visit logout_path
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end


end
