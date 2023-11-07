# frozen_string_literal: true

class DescriptionController < ApplicationController
  before_action :set_current_user_log, only: %i[edit update destroy]

  def index
    @q = current_user.logs.where(log_type: 5).ransack(params[:q])
    @logs = @q.result.includes([:tags]).order(id: 'DESC').page(params[:page]).per(10)
  end

  def edit; end

  def update
    @log.touch
    if @log.update(log_params)
      redirect_to description_index_path, notice: notice_txt
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to description_index_path, notice: notice_txt }
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
                                :description, :date_time, :user_id, :tag_list)
  end
end
