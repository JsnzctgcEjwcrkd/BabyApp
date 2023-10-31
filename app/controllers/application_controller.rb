# frozen_string_literal: true

# It manages pre-action tasks, user authentication, and notification text with an undo option.
class ApplicationController < ActionController::Base
  before_action :ohakon_json
  before_action :authenticate_user!
  before_action :check_demo_user

  def ohakon_json
    @sun_set_rize = SunSetRize.new
  end

  def notice_txt
    if @with_urine_flg
      "#{view_context.print_log_type(@log.log_type)} と \
      #{view_context.print_log_type(2)} を\
      #{view_context.action_text}しました。\
      #{view_context.format_date(@log.date_time)} #{view_context.format_time(@log.date_time)} #{undo_link}"
    else
      "#{view_context.print_log_type(@log.log_type)} を\
      #{view_context.action_text}しました。\
      #{view_context.format_date(@log.date_time)} #{view_context.format_time(@log.date_time)} #{undo_link}"
    end
  end

  private

  def undo_link
    view_context.link_to('取消', revert_version_path(@log.versions.last), method: :post,
                                                                        data: { disable_with: '処理中です' })
  end

  def check_demo_user
    if session[:demo_user]
      @demo_user = true
      @add_demo_title = ' - demo'
    else
      @demo_user = false
      @add_demo_title = ''
    end
  end
end
