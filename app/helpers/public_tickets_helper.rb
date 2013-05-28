module PublicTicketsHelper
  include HelpdeskHelper

  def authoring_public(journal, options={})
    if journal.journal_message && journal.journal_message.from_address
      l(options[:label] || :label_added_time_by, :author => mail_to(journal.journal_message.contact_email), :age => ticket_time_tag(journal.created_on)).html_safe
    else
      l(options[:label] || :label_added_time_by, :author => journal.user.name, :age => ticket_time_tag(journal.created_on)).html_safe
    end
  end

  def ticket_time_tag(time)
    text = distance_of_time_in_words(Time.now, time)
    content_tag('acronym', text, :title => format_time(time))
  end  

end