module ApplicationHelper
  def icon(icon_style, icon_name, size: nil, additional_classes: '')
    classes = ["fa-#{icon_style}", "fa-#{icon_name}", additional_classes]
    classes << "text-#{size}" if size
    tag.i(class: classes)
  end
end
