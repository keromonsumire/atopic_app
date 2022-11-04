class ItchesController < ApplicationController
  require 'date'
  def create
      @region = Region.find(params[:id])
      if Time.current.strftime('%H').to_i > 3 
        @region.itches.create({ date: Date.current }) if !Itch.exists?(region_id: @region.id, date: Date.current)
      else #深夜例外
        @region.itches.create({ date: Date.current.yesterday }) if !Itch.exists?(region_id: @region.id, date: Date.current.yesterday)
      end
      @region.update(interval:1, proactive_start:Date.current)
      redirect_to regions_path
      flash[:success] = "かゆみが記録されました!"
  end
end
