# frozen_string_literal: true

module LogsHelper
  # table_name is for refuctering logs table
  TABLE_ORDER_AND_BG_COLOR = [
    { table_name: 'breast', bg_color_class: 'table-warning' },
    { table_name: 'milk', bg_color_class: 'table-success' },
    { table_name: 'urine', bg_color_class: 'table-info' },
    { table_name: 'stool', bg_color_class: 'table-primary' },
    { table_name: 'body_temperature', bg_color_class: 'table-danger' },
    { table_name: 'description', bg_color_class: 'table-secondary' }
  ].freeze

  def puts_data(day, hour, type)
    time = (@start_date + day).to_time.to_datetime.change(hour:)
    log = @logs.select(:id,
                       :date_time,
                       :milk_amount,
                       :stool_color,
                       :stool_little,
                       :body_temperature,
                       :description)
               .where(date_time: time...(time + 1.hour), log_type: type)
               .order(:date_time)
    link = []
    log.each do |l|
      m = l.date_time.strftime('%M')
      case type

      when 1
        m << " #{l.milk_amount}"
      when 3
        stool_colors = ['(1)', '(2)', '(3)', '(4)', '(5)', '(6)', '(7)']
        m << " #{stool_colors[l.stool_color - 1]}"
        m << " #{tag.i(class: 'fas fa-hand-lizard')}" if l.stool_little
      when 4
        m << " #{l.body_temperature}"
      when 5
        m << " #{tag.i(class: 'fas fa-plus-circle')}"
      end
      link << if type == 5
                tag.a(
                  m.html_safe,
                  class: 'text-decoration-none',
                  role: 'button',
                  tabindex: 0,
                  'data-bs-toggle' => 'popover',
                  'data-bs-trigger' => 'focus',
                  'data-bs-html' => true,
                  'data-bs-content' => "<p>#{safe_join(l.description.split("\n"), tag(:br))}</p>\
                                        <div class='d-grid gap-2'>\
                                          <a class='btn btn-primary btn-sm' href='#{edit_log_path(l)}'>\
                                            編集\
                                          </a>\
                                        </div>"
                )
              else
                link_to(m.html_safe, edit_log_path(l), class: 'text-decoration-none')
              end
    end
    safe_join(link, tag.br)
  end

  def puts_data_4_ajax(date, hour, type)
    type = type.to_i
    time = date.to_time.to_datetime.change(hour: hour.to_i)
    log = Log.select(:id, :date_time, :milk_amount, :stool_color, :stool_little, :body_temperature, :description).where(
      date_time: time...(time + 1.hour), log_type: type
    ).order(:date_time)
    link = []
    log.each do |l|
      m = l.date_time.strftime('%M')
      case type
      when 1
        m << " #{l.milk_amount}"
      when 3
        stool_colors = ['(1)', '(2)', '(3)', '(4)', '(5)', '(6)', '(7)']
        m << " #{stool_colors[l.stool_color - 1]}"
        m << " #{tag.i(class: 'fas fa-hand-lizard')}" if l.stool_little
      when 4
        m << " #{l.body_temperature}"
      when 5
        m << " #{tag.i(class: 'fas fa-plus-circle')}"
      end
      link << if type == 5
                tag.a(
                  m.html_safe,
                  class: 'text-decoration-none',
                  role: 'button',
                  tabindex: 0,
                  'data-bs-toggle' => 'popover',
                  'data-bs-trigger' => 'focus',
                  'data-bs-html' => true,
                  'data-bs-content' => "<p>#{safe_join(l.description.split("\n"), tag(:br))}</p>\
                                        <div class='d-grid gap-2'>\
                                          <a class='btn btn-primary btn-sm' href='#{edit_log_path(l)}'>\
                                            編集\
                                          </a>\
                                        </div>"
                )
              else
                link_to(m.html_safe, edit_log_path(l), class: 'text-decoration-none')
              end
    end
    safe_join(link, tag.br)
  end

  def format_date(date)
    wd = %w[日 月 火 水 木 金 土]
    date.strftime("%-m月%-d日(#{wd[date.wday]})")
  end

  def format_time(date)
    date.strftime('%-H時%-M分')
  end

  def today?(date)
    date == Date.today
  end

  def puts_from_birth(date)
    birth = current_user.setting.birth_day.to_date
    if (date - birth).to_i >= 0
      "（#{(date - birth).to_i}日目）"
    else
      '（ - - - ）'
    end
  end

  def sub_total(date)
    target_date = @start_date + date
    milk_c = @logs.where(date_time: target_date..target_date.end_of_day, log_type: 1).count
    milk_sum = @logs.where(date_time: target_date..target_date.end_of_day, log_type: 1).sum(:milk_amount)
    breasts_c = @logs.where(date_time: target_date..target_date.end_of_day, log_type: 0).count
    tag.strong("母乳 #{breasts_c}回",
               class: 'text-danger fw-bold') + ' ' + tag.strong("ミルク #{milk_c}回 (#{milk_sum}ml)", class: 'text-primary')
  end

  def total(date)
    target_date = @start_date + date
    milk_c = @logs.where(date_time: target_date..target_date.end_of_day, log_type: 1).count
    breasts_c = @logs.where(date_time: target_date..target_date.end_of_day, log_type: 0).count
    tag.strong("合計 #{milk_c + breasts_c}回")
  end

  def check_body_temperature
    if today_body_temperature.count.zero?
      '本日未計測'
    else
      b_t = today_body_temperature.pluck(:body_temperature)
      avg = b_t.sum.fdiv(b_t.length)
      floor_avg = BigDecimal(avg.to_s).floor(1).to_f
      "本日平均 #{floor_avg} °C"
    end
  end

  def set_alert_body_temperature
    return unless Time.zone.now > Time.zone.now.beginning_of_day + 18.hours && today_body_temperature.count.zero?

    "<div id='notice' class='alert alert-warning mt-2'>\
        今日のお熱を計りましょう\
      </div>\
      <script>\
        alert('今日のお熱を計りましょう')\
      </script>".html_safe
  end

  def last_time(type)
    if current_user.logs.where(log_type: type).maximum(:date_time).nil?
      ''
    else
      "#{time_ago_in_words(current_user.logs.where(log_type: type).maximum(:date_time))}前"
    end
  end

  def action_text(name = action_name)
    case name
    when 'new', 'create'
      '登録'
    when 'edit', 'update'
      '更新'
    when 'destroy'
      '削除'
    end
  end

  def edit?
    case action_name
    when 'new'
      false
    when 'edit'
      true
    end
  end

  def print_log_type(i)
    types = %w[母乳 ミルク 尿 便 体温 備考]
    types[i]
  end

  def btn_class_changer
    if @sun_set_rize.night?
      'outline-'
    else
      ''
    end
  end

  private

  def today_body_temperature
    target_date = Date.today
    current_user.logs.where(date_time: target_date..target_date.end_of_day, log_type: 4)
  end

  def month_diff(date)
    d1 = current_user.setting.birth_day.to_date
    d2 = date

    d2 -= d1 - Date.new(d1.year, d1.month, 1)

    diff_months = (d2.year * 12) + d2.month - (d1.year * 12) - d1.month

    diff_years = diff_months / 12
    diff_months -= diff_years * 12
    diff_days = d2.day - 1

    date_text = ''
    case diff_years
    when (..-1)
      '- - -'
    when 0
      if diff_months.zero? && diff_days.zero?
        date_text += "<strong class='text-danger'>★お誕生日★</strong>"
      else
        date_text += '生後 '
        date_text += "#{diff_months}ヶ月" if diff_months != 0
        date_text += "#{diff_days}日" if diff_days != 0
      end
    else
      date_text += "#{diff_years}歳" if diff_years != 0
      if diff_months.zero? && diff_days.zero?
        date_text += " <strong class='text-danger'>★お誕生日★</strong>"
      else
        date_text += "#{diff_months}ヶ月" if diff_months != 0
        date_text += "#{diff_days}日" if diff_days != 0
      end
    end
    date_text.html_safe
  end
end
