require "atd"
require "rack/test"
require "test/unit"

class HomepageTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    MyApp.new
  end

  def test_redirect_logged_in_users_to_dashboard
    authorize "bryan", "secret"
    get "/"
    follow_redirect!

    assert_equal "http://example.org/redirected", last_request.url
    assert last_response.ok?
  end

end