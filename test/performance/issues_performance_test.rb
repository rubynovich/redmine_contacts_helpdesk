# encoding: utf-8
require File.expand_path('../../test_helper', __FILE__)
require 'rails/performance_test_help'
 
class IssuesPerformanceTest < ActionDispatch::PerformanceTest
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries

    ActiveRecord::Fixtures.create_fixtures(Redmine::Plugin.find(:redmine_contacts).directory + '/test/fixtures/', 
                            [:contacts,
                             :contacts_projects,
                             :contacts_issues,
                             :deals,
                             :notes,
                             :tags,
                             :taggings,
                             :contacts_queries])  

    ActiveRecord::Fixtures.create_fixtures(Redmine::Plugin.find(:redmine_contacts_helpdesk).directory + '/test/fixtures/', 
                            [:journal_messages])                                     

  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures/helpdesk_mailer'

  def setup
    RedmineHelpdesk::TestCase.prepare

    ActionMailer::Base.deliveries.clear
    Setting.host_name = 'mydomain.foo'
    Setting.protocol = 'http'
    Setting.plain_text_mail = '0'
  end

  def test_show_issue_with_contacts
    get '/issues/1', credentials('admin')
  end
 

end