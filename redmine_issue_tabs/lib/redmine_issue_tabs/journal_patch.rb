module RedmineIssueTabs
  module JournalPatch
    def self.included(base)
      base.send :include, InstanceMethods
      base.class_eval do
        has_many :rit_journal_attachments, -> { where("#{JournalDetail.table_name}.property = 'attachment' AND #{JournalDetail.table_name}.value is not null AND #{JournalDetail.table_name}.value <> ''") }, class_name: 'JournalDetail', foreign_key: :journal_id
        alias_method_chain :visible_details, :rit
      end
    end

    module InstanceMethods
      def visible_details_with_rit(*args)
        @visible_details ||= visible_details_without_rit(*args)
      end
    end
  end
end