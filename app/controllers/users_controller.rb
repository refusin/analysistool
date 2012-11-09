class UsersController < ApplicationController
  def index
    # get all users in the table locations
    @users = User.all
    @coordenadas=GpsSamples.all
    @gpsJson=@coordenadas.to_json
  end

  def new
    # default: render ’new’ template (\app\views\locations\new.html.haml)
  end

  def create
    # create a new instance variable called @user that holds a Location object built from the data the user submitted
    @user = User.new(params[:user])

    # if the object saves correctly to the database
    if @user.save
      # redirect the user to index
      redirect_to users_path, notice: 'User was successfully created.'
    else
      # redirect the user to the new method
      render action: 'new'
    end
  end

  def destroy
    # find only the location that has the id defined in params[:id]
    @user = User.find(params[:id])

    # delete the location object and any child objects associated with it
    @user.destroy

    # redirect the user to index
    redirect_to users_path, notice: 'User was successfully deleted.'
  end

  def show
    # default: render ’show’ template (\app\views\locations\show.html.haml)
    @user = User.find(params[:id])
    @coordenadas=GpsSamples.find_all_by_iduser(params[:id])
    @gpsJson=@coordenadas.to_json
  end

  def activity
    @user = User.find(params[:id])

    @dTable = Array.new(25)
    @dTable.each_index do |r|
      @dTable[r] = Array.new(8,0)
      @dTable[r][0] = (r.to_int-1).to_s + ":00"
    end
    @dTable[0] = ["Name","Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sabado"]
    act = ActivityCount.find_all_by_userID(params[:id])
    act.each do |activ|
      @dTable[Time.at(activ.time/1000).localtime.hour+1][Time.at(activ.time/1000).localtime.wday+1] += activ.count if activ.count != -1
    end
    @dTable=@dTable.to_json.html_safe

  end





end




