require_dependency 'queries_helper'

module RedmineHelpdesk
  module Patches
    module QueriesHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          alias_method_chain :column_content, :helpdesk
        end
      end


      module InstanceMethods
        include ContactsHelper


        def column_content_with_helpdesk(column, issue)
          if column.name.eql? :last_message 
            last_message = JournalMessage.includes(:journal => :issue).where(:issues => {:id => issue.id}).order("#{Journal.table_name}.created_on ASC").last #.issue.journals.find(:first, :select => :notes, :include => [:journal_message], :conditions => ["#{JournalMessage.table_name}.source IS NOT NULL"], :order => "#{Journal.table_name}.created_on DESC")
            last_message_incoming = last_message.blank? ? true : last_message.is_incoming? 
            last_message_content = last_message.blank? ? issue.description : last_message.journal.notes
            last_message_id = last_message.blank? ? '' : last_message.journal.id
            unless last_message_content.blank? 
              content_tag(:span, '', :class => "icon #{last_message_incoming ? 'icon-email' : 'icon-email-to'}") + 
              link_to(content_tag(:span, content_tag(:small, last_message_content.truncate(250)), :class => 'description'),
                      {:controller => 'issues', :action => 'show', :id => issue.id, :anchor => "change-#{last_message_id}"})
            end
          elsif column.name.eql?(:customer)  
            issue.customer ? link_to_source(issue.customer) : ""
          elsif column.name.eql?(:customer_company)  
            issue.customer ? issue.customer.company : ""
          elsif column.name.eql?(:ticket_source) 
            issue.helpdesk_ticket ? issue.helpdesk_ticket.ticket_source_name : ""
          else  
            column_content_without_helpdesk(column, issue)
          end
        end

      end
    end
  end
end

unless QueriesHelper.included_modules.include?(RedmineHelpdesk::Patches::QueriesHelperPatch)
  QueriesHelper.send(:include, RedmineHelpdesk::Patches::QueriesHelperPatch)
end
