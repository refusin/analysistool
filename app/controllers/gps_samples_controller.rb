class GpsSamplesController < ApplicationController
  def create
    archivo = params[:file]
    gps = JSON.parse(archivo.read)
    gps.each do |g|
      gpssample = GpsSamples.new
      gpssample.latitude = g["latitude"]
      gpssample.longitude = g["longitude"]
      gpssample.time = g["timestamp"]
      gpssample.iduser = params[:id]
      gpssample.save
    end
    redirect_to user_path(params[:id]), notice: 'JSON was successfully upload'
  end
end
