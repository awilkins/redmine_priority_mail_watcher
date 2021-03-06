module PriorityMailWatcher
  
  WATCH_PROJECT_ID = 'ts'
  TOP_PRIORITY_NAME = 'P1 (Critical)'
  ALERT_USER_MAILS = [ 'adrian.wilkins@nhs.net', 'tshird@nhs.net', 'chrismorris@nhs.net' ]
  
  class Hooks < Redmine::Hook::Listener
    
    # Test to see if the issue is a top priority
	def is_top_priority(issue)
      tech_services_project = Project.find_by_identifier(WATCH_PROJECT_ID)
      top_priority = IssuePriority.find_by_name(TOP_PRIORITY_NAME)
      
      if issue.project == tech_services_project && issue.priority == top_priority
		return true
      end
	end
    
    # For brand new issues, add the "Four Horsemen" if it's a P1
    def controller_issues_new_before_save(context={ })
      journal = context[:journal]
      issue = context[:issue]
      
      if is_top_priority(issue)
        add_watchers_if_not_subscribed(issue, journal, ALERT_USER_MAILS)
      end
      
    end
    
    # Add the watchers of the apocalypse to issues that have freshly become P1  
    def controller_issues_edit_before_save(context={ })
      issue = context[:issue]
      journal = context[:journal]
      
      if is_top_priority(issue)
        
        # We are in the middle of the issue save transaction so we can fetch the old one
        old_issue = Issue.find(issue.id)
        
        # If the issue priority changed to P1, add the alert list
        if old_issue.priority != issue.priority        
          add_watchers_if_not_subscribed(issue, journal, ALERT_USER_MAILS)
        end
      end
    end
    
    # Add the users in the list of emails ; but only if they are not
    # already subscribers to the issue
    def add_watchers_if_not_subscribed(issue, journal, mails)
      for mail in mails
        user = User.find_by_mail(mail)
        if issue.assigned_to != user && issue.author != user && !issue.watcher_users.member?(user)
          issue.watcher_users << user
        end
      end
    end
    
  end
  
end
