class ActionView::Helpers::FormBuilder
  def render_errors(attribute_name)
    error_message = @object.errors[attribute_name].first&.sub(/^./, &:upcase)
    return if error_message.blank?
    @template.content_tag(:div, error_message, class: 'error')
  end
end
