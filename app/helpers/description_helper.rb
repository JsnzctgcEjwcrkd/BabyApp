# frozen_string_literal: true

module DescriptionHelper
  def description_cards
    html = ''
    @logs.each do |log|
      html += "<div class='card mb-2'>
                <div class='card-header'>
                  #{log.date_time.strftime('%Y年%m月%d日 %H:%M')}
                  (#{month_diff(log.date_time.to_date)})
                  #{print_tags log}
                  #{link_to '編集', edit_description_path(log), class: 'btn btn-sm btn-primary float-end'}
                </div>
                <div class='card-body'>
                  <p class='card-text'>#{log.description.gsub("\n", '<br>')}</p>
                </div>
              </div>"
    end
    html.html_safe
  end

  private

  def print_tags(log)
    tags = ''
    log.tag_list.each do |tag|
      tags += "<span class='text-success p-1'><i class='fas fa-tag'></i> #{tag}</span>".html_safe
    end
    tags
  end
end
