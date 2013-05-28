require File.expand_path('../../test_helper', __FILE__)

class CommonViewsTest < ActionController::IntegrationTest
  
  def setup
    RedmineHelpdesk::TestCase.prepare

    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env['HTTP_REFERER'] = '/'
  end  
  
  test "View project settings" do
    log_user("admin", "admin")
    get "/projects/ecookbook/settings"
    assert_response :success
  end  

  test "View helpdesk plugin settings" do
    log_user("admin", "admin")
    get "/settings/plugin/redmine_contacts_helpdesk"
    assert_response :success
  end  

end
