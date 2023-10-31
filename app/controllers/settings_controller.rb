# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :set_current_user_setting, only: %i[edit update edit_birth_setting update_birth_setting]

  def edit; end

  def update
    if @setting.update(setting_params)
      redirect_to logs_path, notice: '設定を更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit_birth_setting; end

  def update_birth_setting
    if @setting.update(setting_params)
      redirect_to logs_path, notice: birth_setting_notice_txt
    else
      render :edit_birth_setting, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_current_user_setting
    @setting = current_user.setting
  end

  # Only allow a list of trusted parameters through.
  def setting_params
    params.require(:setting).permit(:birth_day, :latitude, :longitude, :night_mode, :border_line, :milk_default,
                                    :milk_min, :milk_max, :stool_color_default, :body_temp_default, :user_id)
  end

  def birth_setting_notice_txt
    if @setting.birth_day <= Time.zone.now.beginning_of_day
      '出産おめでとうございます！赤ちゃんの健康な成長をお祈りしています。'
    else
      '妊娠おめでとうございます！母子ともに健康な出産をお祈りしています。'
    end
  end
end
