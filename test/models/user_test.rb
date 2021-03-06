require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(name: "ahmed", email: "ai.abdelnabi@gmail.com", password: "123456", password_confirmation: "123456")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "Name Should be presence" do
		@user.name = " "
		assert_not @user.valid?
	end

	test "Email Should be presence" do
		@user.email = " "
		assert_not @user.valid?
	end

	test "name Should not ne too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email Should not be too long" do
		@user.email = "a" * 256
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
		valid_addresses = %w[user@example.com USER@foo.COM A_US@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
		valid_addresses.each do |valid_address|
			@user.email = valid_address
			assert @user.valid?
		end
	end

	test "email validation should reject invalid addresses" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@Example. foo@bar_baz.com foo@bar+baz.com]
		invalid_addresses.each do |invalid_address|
			@user.email = invalid_address
			assert_not @user.valid?
		end
	end

	test "email address should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "email address should be save as downcase" do
		@user.email = "MYEMAIL@EXAMPLE.COM"
		@user.save
		assert_equal "myemail@example.com", @user.email
	end

	test "email address should not be save as upcase" do
		@user.email = "MYEMAIL@EXAMPLE.COM"
		@user.save
		assert_not_equal "MYEMAIL@EXAMPLE.COM", @user.email
	end

	test "password should not be less than 6" do
		@user.password = @user.password_confirmation = "a" * 5

		assert_not @user.valid?
	end

	test "authenticated? should return false for a user with nil digest" do
		assert_not @user.authenticated?(:remember, '')
	end

	test "associated mircopost should be destroyed" do
		@user.save
		@user.microposts.create!(content: "lorem ipsum")
		assert_difference "Micropost.count", -1 do
			@user.destroy
		end
	end

	test "should follow and unfollow a user" do
		michael = users(:michael)
		archer  = users(:archer)
		assert_not michael.following?(archer)
		michael.follow(archer)
		assert michael.following?(archer)
		assert archer.followers.include?(michael)
		michael.unfollow(archer)
		assert_not michael.following?(archer)
	end

	test "feed should have the right posts" do
		michael = users(:michael)
		archer  = users(:archer)
		lana    = users(:lana)
		# Posts from followed user
		lana.microposts.each do |post_following|
			assert michael.feed.include?(post_following)
		end
		# Posts form self
		michael.microposts.each do |post_self|
			assert michael.feed.include?(post_self)
		end

		# Posts from unfollowed user
		archer.microposts.each do |post_unfollow|
			assert_not michael.feed.include?(post_unfollow)
		end
	end
end
