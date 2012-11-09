class ActivityCountsController < ApplicationController
  def create
    archivo = params[:file]
    act = JSON.parse(archivo.read)
    act.each do |g|
      activityCount = ActivityCount.new
      activityCount.time = g["timestamp"]
      activityCount.count = g["count"]
      activityCount.userID = params[:id]
      activityCount.save
    end
    redirect_to users_activity_path(params[:id]), notice: 'JSON was successfully upload'
  end

end
