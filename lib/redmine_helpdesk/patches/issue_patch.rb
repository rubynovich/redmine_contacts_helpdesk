module RedmineHelpdesk
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do    
          unloadable # Send unloadable so it will not be unloaded in development
          has_one :customer, :through => :helpdesk_ticket
          has_one :helpdesk_ticket, :dependent => :delete

          accepts_nested_attributes_for :helpdesk_ticket

          safe_attributes 'helpdesk_ticket_attributes',
            :if => lambda {|issue, user| user.allowed_to?(:edit_helpdesk_tickets, issue.project)}

        end          
      end


      module InstanceMethods
        def last_message
          message = self.journals.find(:first, :select => :notes, :include => [:journal_message], :conditions => ["#{JournalMessage.table_name}.source IS NOT NULL"], :order => "#{Journal.table_name}.created_on DESC").try(:notes)
          message.truncate(250) if message
        end

        def ticket_source
          self.helpdesk_ticket.ticket_source_name if self.helpdesk_ticket
        end

        def customer_company
          return nil unless self.customer
          self.customer.company
        end        

      end

    end
  end
end

unless Issue.included_modules.include?(RedmineHelpdesk::Patches::IssuePatch)
  Issue.send(:include, RedmineHelpdesk::Patches::IssuePatch)
end
