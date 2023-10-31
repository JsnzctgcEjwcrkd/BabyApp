# frozen_string_literal: true

class ChartController < ApplicationController
  def index
    if params[:disp]
      session[:days] = params[:disp].to_i
    else
      session[:days] ||= 7
    end
    @days = session[:days]

    @display_ago = 0
    @display_ago = session[:display_ago]
    if params[:display_ago].present?
      @display_ago = if params[:display_ago] == '1'
                       1
                     else
                       0
                     end
    end
    session[:display_ago] = @display_ago
    @display_ago_toggle_class = @display_ago == 1 ? 'active' : ''
    @display_ago_toggle = @display_ago == 1 ? 'true' : 'false'

    @current_date = session[:current_date]&.to_date || Time.zone.today
    if params[:move]
      if params[:move].to_i.zero?
        @current_date = Time.zone.today
      else
        @current_date += params[:move].to_i
      end
      session[:current_date] = @current_date
    end

    case @days
    when 1
      @start_date = @current_date
      logs = current_user.logs.where(date_time: @start_date..(@current_date + 1.day))
      @end_date = (@current_date + 1.day)
    when 3
      @start_date = @current_date - 2
      logs = current_user.logs.where(date_time: @start_date..(@current_date + 1.day))
      @end_date = (@current_date + 1.day)
    else
      if @display_ago == 1
        @start_date = @current_date - 6
        logs = current_user.logs.where(date_time: @start_date..(@current_date + 1.day))
        @end_date = (@current_date + 1.day)
      else
        @start_date = @current_date.beginning_of_week(:sunday)
        logs = current_user.logs.where(date_time: @start_date..(@current_date.end_of_week(:sunday) + 1.day))
        @end_date = (@current_date.end_of_week(:sunday) + 1.day)
      end
    end

    bt_log = logs.where(log_type: 4).order(date_time: 'ASC')
    @data_keys = bt_log.pluck(:date_time).to_json       # ['09:30', '11:10', '13:00', '15:00', '18:30', '19:50']
    @data_values = bt_log.pluck(:body_temperature)
  end
end
