module RedmineIssueTabs
  module IssuePatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        attr_accessor :rit_journal_load_skip

        alias_method_chain :visible_journals_with_index, :rit
      end
    end

    module InstanceMethods
      def visible_journals_with_index_with_rit(*args)
        # just hack to prevent loading a history of issue (true set in issues_controller_patch)
        if self.rit_journal_load_skip
          self.rit_journal_load_skip = false
          []
        else
          visible_journals_with_index_without_rit(*args)
        end
      end
    end
  end
end