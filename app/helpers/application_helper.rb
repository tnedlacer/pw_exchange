module ApplicationHelper
  
  def form_group_class(object, attr)
    ["form-group", object.errors[attr].present? ? "has-error" : nil].compact
  end
  
  def simple_format_error_message(object, attr)
    return nil if object.errors[attr].blank?
    simple_format(object.errors.full_messages_for(attr).join("\n"), class: 'help-block')
  end
  
end
