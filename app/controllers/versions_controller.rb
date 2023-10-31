# frozen_string_literal: true

class VersionsController < ApplicationController
  def revert
    @version = PaperTrail::Version.find(params[:id])
    if @version.reify
      @version.reify.save!
      redirect_back(fallback_location: logs_path, notice: "#{view_context.action_text(@version.event)}を取り消しました。")
    else
      @version.item.destroy
      redirect_to(logs_path, notice: "#{view_context.action_text(@version.event)}を取り消しました。")
    end
  end
end
