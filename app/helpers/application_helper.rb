module ApplicationHelper
    def icon(icon_style, icon_name, size: nil)
      classes = ["fa-#{icon_style}", "fa-#{icon_name}"]
      classes << "text-#{size}" if size
      tag.i(class: classes)
    end
  end
  