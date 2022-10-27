module RedmineIssueTabs
  module JournalsHelperPatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        alias_method_chain :journal_thumbnail_attachments, :rit
      end
    end

    module InstanceMethods
      # full repatch
      def journal_thumbnail_attachments_with_rit(journal)
        ids = journal.rit_journal_attachments.map(&:prop_key)
        ids.any? ? Attachment.where(id: ids).select(&:thumbnailable?) : []
      end
    end
  end
end