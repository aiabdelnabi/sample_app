require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	
	def setup
		ActionMailer::Base.deliveries.clear
	end

	test "invalid signup information" do
		get signup_path
		assert_no_difference 'User.count' do
			post users_path, user: { name: "", email: "", password: "", password_confirmation: "" }
		end
		assert_template "users/new"
	end

	test "valid signup information" do
		get signup_path
		assert_difference 'User.count', 1 do
			post users_path, user: { name: "ahmed", email: "ahmed@yahoo.com", password: "123456", password_confirmation: "123456" }
		end
		assert_equal 1, ActionMailer::Base.deliveries.size
		user = assigns(:user)
		assert_not user.activated?
		# Try to log in before activation
		log_in_as(user)
		assert_not is_logged_in?
		# Invalid activation token
		get edit_account_activation_path("invalid token")
		assert_not is_logged_in?
		get edit_account_activation_path(user.activation_token, email: 'wrong')
		assert_not is_logged_in?
		get edit_account_activation_path(user.activation_token, email: user.email)
		user.reload
		assert user.activated?
		follow_redirect!
		#assert_template 'users/show'
		#assert is_logged_in?
	end
end
