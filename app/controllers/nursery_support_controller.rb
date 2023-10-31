# frozen_string_literal: true

class NurserySupportController < ApplicationController
  def index
    if params[:support].present?
      @start_date = Time.zone.local(params[:support]['start_time(1i)'].to_i,
                                    params[:support]['start_time(2i)'].to_i,
                                    params[:support]['start_time(3i)'].to_i,
                                    params[:support]['start_time(4i)'].to_i,
                                    params[:support]['start_time(5i)'].to_i)
      @end_date = Time.zone.local(params[:support]['end_time(1i)'].to_i,
                                  params[:support]['end_time(2i)'].to_i,
                                  params[:support]['end_time(3i)'].to_i,
                                  params[:support]['end_time(4i)'].to_i,
                                  params[:support]['end_time(5i)'].to_i)
      if (@end_date.to_date - @start_date.to_date).to_i > 7
        set_default_span
        flash.now[:alert] = '7日間を超える指定はできません。'
      end
    else
      set_default_span
    end
    @bt_logs = current_user.logs.where(date_time: @start_date..@end_date, log_type: [4, 5]).order(:date_time)
    @sleep_logs = current_user.logs.where(date_time: @start_date..@end_date).tagged_with(%w[寝た 起きた],
                                                                                         any: true).order(:date_time)
    @milk_meal_logs = current_user.logs.where(date_time: @start_date..@end_date, log_type: [1, 5]).order(:date_time)
    @memo_logs = current_user.logs.where(date_time: @start_date..@end_date).tagged_with('保育園メモ').order(:date_time)
    @topics_logs = current_user.logs.where(date_time: @start_date..@end_date).tagged_with('連絡帳ネタ').order(:date_time)
  end

  private

  def set_default_span
    @start_date = if Time.zone.now.hour >= 12
                    Date.current.beginning_of_day + 12.hour
                  else
                    (Date.current - 1.day).beginning_of_day + 12.hour
                  end
    @end_date = Time.zone.now
  end
end
