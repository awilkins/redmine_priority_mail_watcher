require 'redmine'
require_dependency 'redmine_priority_mail_watcher/hooks'


Redmine::Plugin.register :redmine_priority_mail_watcher do
  name 'Tech Services Priority Mail Watcher plugin'
  author 'Adrian Wilkins'
  description 'This plugin watches for high priority issues and adds a set list of watchers to them.\nIt\'s currently rather primitive and is configured by re-writing the source code..'
  version '0.0.1'
  url ''
  author_url ''
end
