# frozen_string_literal: true

module NurserySupportHelper
  def body_temp_summary
    html = ''
    date_buf = nil
    @bt_logs.each do |log|
      if log.date_time.to_date != date_buf
        date_buf = log.date_time.to_date
        html += "<h5 class='fw-bold'>#{log.date_time.to_date.strftime('%m/%-d')}</h5>"
      end

      case log.log_type
      when 4
        html += "<p>#{log.date_time.strftime('%H:%M')} | #{log.body_temperature} °C</p>"
      when 5
        tag_html = ''
        log.tag_list.each do |tag|
          next unless tag == 'パパママ体温'

          tag_html += "<span class='text-success p-1'><i class='fas fa-tag'></i> #{tag}</span>"
          html += "<div class='card mb-2'>
          <div class='card-header'>
          #{log.date_time.strftime('%H:%M')} #{tag_html}
          </div>
          <div class='card-body'>
            <p class='card-text'>#{log.description.gsub("\n", '<br>')}</p>
          </div>
          </div>"
        end
      end
    end
    html.html_safe
  end

  def sleep_summary
    html = ''
    date_buf = nil
    sw = false
    start = nil
    stop = nil
    total = 0
    @sleep_logs.each do |log|
      if log.date_time.to_date != date_buf
        date_buf = log.date_time.to_date
        if sw
          html += '</p>'
          sw = false
        end
        html += "<h5 class='fw-bold'>#{log.date_time.to_date.strftime('%m/%-d')}</h5>"
      end
      log.tag_list.each do |tag|
        case tag
        when '寝た'
          html += '</p>' if sw
          html += "<p>#{log.date_time.strftime('%H:%M')}"
          html += ' ～ '
          start = log.date_time
          sw = true
        when '起きた'
          html += '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ～ ' unless sw
          stop = log.date_time
          if start && stop
            sec = (stop - start).round
            total += sec
            html += "#{log.date_time.strftime('%H:%M')} (#{Time.at(sec).utc.strftime('%-H:%M')})</p>"
          else
            html += "#{log.date_time.strftime('%H:%M')}</p>"
          end
          sw = false
        end
      end
    end
    html += "<p>合計 #{Time.at(total).utc.strftime('%-H時間%M分')}</p>"
    html.html_safe
  end

  def milk_meal_summary
    html = ''
    date_buf = nil
    @milk_meal_logs.each do |log|
      if log.date_time.to_date != date_buf
        date_buf = log.date_time.to_date
        html += "<h5 class='fw-bold'>#{log.date_time.to_date.strftime('%m/%-d')}</h5>"
      end
      case log.log_type
      when 1
        html += "<p>#{log.date_time.strftime('%H:%M')} | ミルク #{log.milk_amount} cc</p>"
      when 5
        tag_html = ''
        log.tag_list.each do |tag|
          next unless %w[離乳食 お白湯].include?(tag)

          tag_html += "<span class='text-success p-1'><i class='fas fa-tag'></i> #{tag}</span>"
          html += "<div class='card mb-2'>
          <div class='card-header'>
          #{log.date_time.strftime('%H:%M')} #{tag_html}
          </div>
          <div class='card-body'>
            <p class='card-text'>#{log.description.gsub("\n", '<br>')}</p>
          </div>
          </div>"
        end
      end
    end
    html.html_safe
  end

  def memo_summary
    html = ''
    date_buf = nil
    @memo_logs.each do |log|
      if log.date_time.to_date != date_buf
        date_buf = log.date_time.to_date
        html += "<h5 class='fw-bold'>#{log.date_time.to_date.strftime('%m/%-d')}</h5>"
      end
      html += "<div class='card mb-2'>
      <div class='card-header'>
      #{log.date_time.strftime('%H:%M')}
      </div>
      <div class='card-body'>
        <p class='card-text'>#{log.description.gsub("\n", '<br>')}</p>
      </div>
    </div>"
    end
    html.html_safe
  end

  def topics_summary
    html = ''
    date_buf = nil
    @topics_logs.each do |log|
      if log.date_time.to_date != date_buf
        date_buf = log.date_time.to_date
        html += "<h5 class='fw-bold'>#{log.date_time.to_date.strftime('%m/%-d')}</h5>"
      end
      html += "<div class='card mb-2'>
      <div class='card-header'>
      #{log.date_time.strftime('%H:%M')}
      </div>
      <div class='card-body'>
        <p class='card-text'>#{log.description.gsub("\n", '<br>')}</p>
      </div>
    </div>"
    end
    html.html_safe
  end
end
