module RedmineHelpdesk
  module Patches    
    
    module ContactPatch
      def self.included(base) # :nodoc: 
        base.send(:include, InstanceMethods)
        base.class_eval do    
          unloadable # Send unloadable so it will not be unloaded in development
          has_many :journals, :through => :journal_messages
          has_many :journal_messages, :dependent => :delete_all

          has_many :tickets, :through => :helpdesk_tickets, :source => :issue #class_name => "Issue", :as  => :issue, :foreign_key => 'issue_id'   
          has_many :helpdesk_tickets, :dependent => :delete_all
        end  
      end  

      module InstanceMethods
        def mail
          self.primary_email
        end
      end

    end

  end
end

unless Contact.included_modules.include?(RedmineHelpdesk::Patches::ContactPatch)
  Contact.send(:include, RedmineHelpdesk::Patches::ContactPatch)
end
