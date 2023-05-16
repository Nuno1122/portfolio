module Kaminari
  class BtnGroupRenderer < Kaminari::Helpers::Paginator
    def to_s
      html = ''.html_safe
      each_page do |page|
        if page.left_outer? || page.right_outer? || page.inside_window?
          html << page_tag(page, class: "btn #{'btn-disabled' if page.current?}")
        elsif !page.was_truncated?
          html << gap_tag(class: 'btn btn-disabled')
        end
      end
      html
    end
  end
end
