require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	
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
			post_via_redirect users_path, user: { name: "ahmed", email: "ahmed@yahoo.com", password: "123456", password_confirmation: "123456" }
		end
		assert_template 'users/show'
	end
end
