class ItchesController < ApplicationController
  require 'date'
  def create
      @region = Region.find(params[:id])
      if Time.current.strftime('%H').to_i > 3 #深夜4時以降
        @region.itches.create({ date: Date.current }) if !Itch.exists?(region_id: @region.id, date: Date.current)
      else #深夜3時59分まで
        @region.itches.create({ date: Date.current.yesterday }) if !Itch.exists?(region_id: @region.id, date: Date.current.yesterday)
      end
      @region.update(interval:1)
      redirect_to regions_path
      flash[:success] = "かゆみが記録されました!"
  end
end
