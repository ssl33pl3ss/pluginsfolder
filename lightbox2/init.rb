require 'redmine'

Redmine::Plugin.register :redmine_x_lightbox2 do
  name 'RedmineX Lightbox2'
  author 'Tobias Fischer, forked by RedmineX'
  description 'This plugin lets you preview image and pdf attachments in a lightbox.'
  version '1.0.0'
  url 'www.redmine-x.com'
  author_url 'https://github.com/tofi86'
  requires_redmine :version_or_higher => '5.0'
end

base_path = File.dirname(__FILE__)
if Rails.configuration.respond_to?(:autoloader) && Rails.configuration.autoloader == :zeitwerk
  Rails.autoloaders.each { |loader| loader.ignore("#{base_path}/lib") }
end
require "#{base_path}/lib/redmine_x_lightbox2"



# Patches to the Redmine core.
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

if Rails::VERSION::MAJOR >= 5
  ActiveSupport::Reloader.to_prepare do
    require_dependency 'attachments_controller'
    AttachmentsController.send(:include, RedmineLightbox2::AttachmentsPatch)
  end
elsif Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    require_dependency 'attachments_controller'
    AttachmentsController.send(:include, RedmineLightbox2::AttachmentsPatch)
  end
else
  Dispatcher.to_prepare do
    require_dependency 'attachments_controller'
    AttachmentsController.send(:include, RedmineLightbox2::AttachmentsPatch)
  end
end
