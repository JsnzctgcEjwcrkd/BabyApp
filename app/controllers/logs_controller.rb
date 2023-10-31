# frozen_string_literal: true

class LogsController < ApplicationController
  skip_before_action :ohakon_json, only: :logs_ajax
  before_action :check_birthday
  before_action :set_current_user_log, only: %i[show edit update destroy]

  # GET /logs or /logs.json
  def index
    params[:disp] ? session[:days] = params[:disp].to_i : session[:days] ||= 7
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
      @logs = current_user.logs.where(date_time: @start_date..(@current_date + 1.day))
    when 3
      @start_date = @current_date - 2
      @logs = current_user.logs.where(date_time: @start_date..(@current_date + 1.day))
    else
      if @display_ago == 1
        @start_date = @current_date - 6
        @logs = current_user.logs.where(date_time: @start_date..(@current_date + 1.day))
      else
        @start_date = @current_date.beginning_of_week(:sunday)
        @logs = current_user.logs.where(date_time: @start_date..(@current_date.end_of_week(:sunday) + 1.day))
      end
    end
  end

  def logs_ajax
    @logs = current_user.logs
                        .where(date_time: params[:startDate].to_date..(params[:startDate].to_date + params[:days].to_i.day))
                        .order(date_time: 'ASC')
                        .order(id: 'ASC')
    render json: { logs: @logs }
  end

  # GET /logs/1 or /logs/1.json
  def show; end

  # GET /logs/new
  def new
    type = params[:type].to_i
    @log = current_user.logs.build(log_type: type)
    case type
    when 1
      @log.milk_amount = 120
    when 4
      @log.body_temperature = 37.0
    end
  end

  # GET /logs/1/edit
  def edit; end

  # POST /logs or /logs.json
  def create
    @log = current_user.logs.new(log_params)
    @with_urine_flg = false
    respond_to do |format|
      if @log.save
        if params[:log][:add_urine] == '1'
          current_user.logs.create!(log_type: 2, date_time: @log.date_time)
          @with_urine_flg = true
        end
        format.html do
          redirect_to logs_url, notice: notice_txt
        end
        format.json { render :show, status: :created, location: @log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logs/1 or /logs/1.json
  def update
    respond_to do |format|
      @log.touch
      if @log.update(log_params)
        format.html do
          redirect_to logs_url, notice: notice_txt
        end
        format.json { render :show, status: :ok, location: @log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1 or /logs/1.json
  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to logs_url, notice: notice_txt }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_current_user_log
    @log = current_user.logs.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def log_params
    params.require(:log).permit(:log_type, :milk_amount, :stool_little, :stool_color, :body_temperature,
                                :description, :date_time, :user_id, :add_urine, :tag_list)
  end

  def check_birthday
    if current_user.setting.nil?
      current_user.build_setting
      current_user.setting.save(validate: false)
    end
    return unless current_user.setting.birth_day.nil?

    if @demo_user
      current_user.setting.update(birth_day: Date.today - 6.days)
    else
      redirect_to birth_setting_path, notice: 'ようこそBabyAppへ！お子様のお誕生日を設定してください。'
    end
  end
end
