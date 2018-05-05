require_dependency 'issues_helper'

module IssueHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :show_detail, :editor
    end
  end

  module InstanceMethods

    def show_detail_with_editor(detail, no_html = false, options = {})
      multiple = false
      case detail.property
      when 'attr'
        field = detail.prop_key.to_s.gsub(/\_id$/, "")
        label = l(("field_" + field).to_sym)
        case detail.prop_key
        when 'due_date', 'start_date'
          value = format_date(detail.value.to_date) if detail.value
          old_value = format_date(detail.old_value.to_date) if detail.old_value

        when 'project_id', 'status_id', 'tracker_id', 'assigned_to_id',
            'priority_id', 'category_id', 'fixed_version_id'
          value = find_name_by_reflection(field, detail.value)
          old_value = find_name_by_reflection(field, detail.old_value)

        when 'editor_id'
          value =  User.find(detail.value) unless detail.value.blank?
          old_value = User.find(detail.old_value) unless detail.old_value.blank?

        when 'estimated_hours'
          value = "%0.02f" % detail.value.to_f unless detail.value.blank?
          old_value = "%0.02f" % detail.old_value.to_f unless detail.old_value.blank?

        when 'parent_id'
          label = l(:field_parent_issue)
          value = "##{detail.value}" unless detail.value.blank?
          old_value = "##{detail.old_value}" unless detail.old_value.blank?

        when 'is_private'
          value = l(detail.value == "0" ? :general_text_No : :general_text_Yes) unless detail.value.blank?
          old_value = l(detail.old_value == "0" ? :general_text_No : :general_text_Yes) unless detail.old_value.blank?
        end
      when 'cf'
        custom_field = detail.custom_field
        if custom_field
          multiple = custom_field.multiple?
          label = custom_field.name
          value = format_value(detail.value, custom_field) if detail.value
          old_value = format_value(detail.old_value, custom_field) if detail.old_value
        end
      when 'attachment'
        label = l(:label_attachment)
      when 'relation'
        if detail.value && !detail.old_value
          rel_issue = Issue.visible.find_by_id(detail.value)
          value = rel_issue.nil? ? "#{l(:label_issue)} ##{detail.value}" :
                      (no_html ? rel_issue : link_to_issue(rel_issue, :only_path => options[:only_path]))
        elsif detail.old_value && !detail.value
          rel_issue = Issue.visible.find_by_id(detail.old_value)
          old_value = rel_issue.nil? ? "#{l(:label_issue)} ##{detail.old_value}" :
                          (no_html ? rel_issue : link_to_issue(rel_issue, :only_path => options[:only_path]))
        end
        relation_type = IssueRelation::TYPES[detail.prop_key]
        label = l(relation_type[:name]) if relation_type
      end
      call_hook(:helper_issues_show_detail_after_setting,
                {:detail => detail, :label => label, :value => value, :old_value => old_value})

      label ||= detail.prop_key
      value ||= detail.value
      old_value ||= detail.old_value

      unless no_html
        label = content_tag('strong', label)
        old_value = content_tag("i", h(old_value)) if detail.old_value
        if detail.old_value && detail.value.blank? && detail.property != 'relation'
          old_value = content_tag("del", old_value)
        end
        if detail.property == 'attachment' && !value.blank? && atta = Attachment.find_by_id(detail.prop_key)
          # Link to the attachment if it has not been removed
          value = link_to_attachment(atta, :download => true, :only_path => options[:only_path])
          if options[:only_path] != false && atta.is_text?
            value += link_to(
                image_tag('magnifier.png'),
                :controller => 'attachments', :action => 'show',
                :id => atta, :filename => atta.filename
            )
          end
        else
          value = content_tag("i", h(value)) if value
        end
      end

      if detail.property == 'attr' && detail.prop_key == 'description'
        s = l(:text_journal_changed_no_detail, :label => label)
        unless no_html
          diff_link = link_to 'diff',
                              {:controller => 'journals', :action => 'diff', :id => detail.journal_id,
                               :detail_id => detail.id, :only_path => options[:only_path]},
                              :title => l(:label_view_diff)
          s << " (#{ diff_link })"
        end
        s.html_safe
      elsif detail.value.present?
        case detail.property
        when 'attr', 'cf'
          if detail.old_value.present?
            l(:text_journal_changed, :label => label, :old => old_value, :new => value).html_safe
          elsif multiple
            l(:text_journal_added, :label => label, :value => value).html_safe
          else
            l(:text_journal_set_to, :label => label, :value => value).html_safe
          end
        when 'attachment', 'relation'
          l(:text_journal_added, :label => label, :value => value).html_safe
        end
      else
        l(:text_journal_deleted, :label => label, :old => old_value).html_safe
      end
    end
  end
end

IssuesHelper.send(:include, IssueHelperPatch)