require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
	def setup
		@micropost = microposts(:orange)
	end

	test "Should redirect create when not logged in" do
		assert_no_difference "Micropost.count" do
			post :create, micropost: { content: "Lorem ipsum" }
		end
		assert_redirected_to login_url
	end

	test "Should redirect destroy when not logged in" do
		assert_no_difference "Micropost.count" do
			delete :destroy, id: @micropost
		end
		assert_redirected_to login_url
	end

	test "should redirect destro for wrong micropost" do
		log_in_as(users(:michael))
		assert_no_difference "Micropost.count" do
			delete :destroy, id: microposts(:ants)
		end
	end
end
