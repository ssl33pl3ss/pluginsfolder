Redmine::Plugin.register :redmine_issue_tabs do
  name 'Redmine Issue Tabs plugin'
  author 'Pitin Vladimir, Kovalevskiy Vasil'
  description 'Plugin enhances issue interface by adding several useful tabs: timelog, time spent, code commits, history'
  version '1.3.4'
  url 'http://rmplus.pro/redmine/plugins/issue_tabs'
  author_url 'http://rmplus.pro/'

  requires_redmine '4.0.0'

  p = Redmine::AccessControl.permission(:view_issues)
  if p && p.project_module == :issue_tracking
    p.actions << 'issues/rit_history'
  end
end

Rails.application.config.to_prepare do
  require 'redmine_issue_tabs/view_hooks'

  Issue.send(:include, RedmineIssueTabs::IssuePatch) unless Issue.included_modules.include?(RedmineIssueTabs::IssuePatch)
  Journal.send(:include, RedmineIssueTabs::JournalPatch) unless Journal.included_modules.include?(RedmineIssueTabs::JournalPatch)
  JournalsHelper.send(:include, RedmineIssueTabs::JournalsHelperPatch) unless JournalsHelper.included_modules.include?(RedmineIssueTabs::JournalsHelperPatch)
  IssuesController.send(:include, RedmineIssueTabs::IssuesControllerPatch) unless IssuesController.included_modules.include?(RedmineIssueTabs::IssuesControllerPatch)

  Acl::Settings.append_setting('enable_javascript_patches', :redmine_issue_tabs)
end

Rails.application.config.after_initialize do
  plugins = { a_common_libs: '2.5.4' }
  plugin = Redmine::Plugin.find(:redmine_issue_tabs)
  plugins.each do |k,v|
    begin
      plugin.requires_redmine_plugin(k, v)
    rescue Redmine::PluginNotFound => ex
      raise(Redmine::PluginNotFound, "Plugin requires #{k} not found")
    end
  end
end


