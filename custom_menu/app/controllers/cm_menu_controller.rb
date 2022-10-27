class CmMenuController < ApplicationController
  self.main_menu = false
  layout 'admin'

  before_action :require_admin
  before_action :find_item, only: [:destroy, :update, :edit]
  before_action :build_new_item, only: [:new, :create]

  helper :cm_menu

  #TODO: need to refactor

  def index
    @top_menu_items = CmItem.where(menu: 'top_menu').sorted
    @account_menu_items = CmItem.where(menu: 'account_menu').sorted
  end

  def rebuild_menu
    p = params.to_unsafe_hash
    top_tree = p[:top_menu]
    account_tree = p[:account_menu]
    CmItem.transaction do
      CmItem.destroy_all

      @errors = {}
      @errors = build_tree(top_tree, 'top_menu') if top_tree.present?
      @errors = @errors.merge(build_tree(account_tree, 'account_menu')) if account_tree.present?

      if @errors.present?
        raise ActiveRecord::Rollback
      end
    end

    if @errors.blank? && (Setting.plugin_custom_menu || {})['use_cache']
      Thread.new do
        Rails.cache.delete_matched(/custom_menu\/\d+\/\w+\/\w+\/user_menu/, nil)
      end
    end
  end

  private

  def build_new_item
    p = params.to_unsafe_hash
    @item = CmItem.new_subclass_instance(p[:type] || (p[:cm_item] || {})[:type], p[:cm_item])
    if @item.blank?
      render_404
    end
  end

  def find_item
    @item = CmItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def build_tree(tree, menu, parent=nil)
    errors_list = {}
    tree.each do |k, t|
      opts = t.except(:type, :roles, :id, :children, :options_class, :nodeid)
      opts[:menu] = menu
      opts[:options] = { class: t[:options_class] }.with_indifferent_access
      item = CmItem.new_subclass_instance(t[:type], opts.with_indifferent_access)

      item.visibility = CmItem::VISIBILITY_PUBLIC if item.visibility.blank?

      if t[:roles].present? && item.visibility == CmItem::VISIBILITY_ROLE
        item.role_ids = Role.where(id: t[:roles].split(',')).pluck(:id)
      else
        item.role_ids = [];
      end

      next if item.blank?

      item.parent_id = parent.try(:id)
      unless item.save
        errors_list[t[:id]] ||= []
        errors_list[t[:id]] += item.errors.full_messages
        next
      end

      if t[:children].present? && t[:children].is_a?(Hash) && !item.new_record?
        errors_list = errors_list.merge(build_tree(t[:children], menu, item))
      end
    end
    errors_list
  end
end