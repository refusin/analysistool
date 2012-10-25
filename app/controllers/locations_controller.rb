class LocationsController < ApplicationController
  def index
    # get all locations in the table locations
    @locations = Location.all

    # to json format
    @locations_json = @locations.to_json
  end

  def new
    # default: render ’new’ template (\app\views\locations\new.html.haml)
  end

  def create
    # create a new instance variable called @location that holds a Location object built from the data the user submitted
    @location = Location.new(params[:location])

    # if the object saves correctly to the database
    if @location.save
      # redirect the user to index
      redirect_to locations_path, notice: 'Location was successfully created.'
    else
      # redirect the user to the new method
      render action: 'new'
    end
  end

  def edit
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])
  end

  def update
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])

    # if the object saves correctly to the database
    if @location.update_attributes(params[:location])
      # redirect the user to index
      redirect_to locations_path, notice: 'Location was successfully updated.'
    else
      # redirect the user to the edit method
      render action: 'edit'
    end
  end

  def destroy
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])

    # delete the location object and any child objects associated with it
    @location.destroy

    # redirect the user to index
    redirect_to locations_path, notice: 'Location was successfully deleted.'
  end

  def destroy_all
    # delete all location objects and any child objects associated with them
    Location.destroy_all

    # redirect the user to index
    redirect_to locations_path, notice: 'All locations were successfully deleted.'
  end

  def show
    # default: render ’show’ template (\app\views\locations\show.html.haml)
    @location = Location.find(params[:id])
  end

  def verificar
    @locations = Location.all
    @locationP=Location.new(params[:location])
    if !params[:location].nil?
      @output = where?(@locationP, @locations, 100)
    end
  end

  def casco
    @perimetro=0
    @locations = Location.all
    @output = ConvexHul.calculate(@locations)
    #Calculo de perimetro del casco convexo
    i=0
    j=1
    while i<=@output.length-1
      if i==@output.length-1
        j=0
      end
      @perimetro=@perimetro+distance(@output[i],@output[j])
      i=i+1
      j=i+1
    end
    #Distancia mas lejana de home
    @locations.each do |location|
      if location.name.downcase=="home"
        @farthest=0
        @output.each do |l2|
          temp=distance(location,l2)
          if temp>=@farthest
            @farthest=temp
          end
        end

      end
    end
  end

  def toRadians(degree)
    return degree*Math::PI/180
  end

  def distance(l1,l2)
    lat1=l1.latitude
    lat2=l2.latitude
    lon1=l1.longitude
    lon2=l2.longitude
    radius = 6371 #radio de la tierra en km
    dlat=toRadians(lat2-lat1)
    dlon=toRadians(lon2-lon1)
    lat1=toRadians(lat1)
    lat2=toRadians(lat2)
    a=Math.sin(dlat/2)*Math.sin(dlat/2)+Math.cos(lat1)*Math.cos(lat2)*Math.sin(dlon/2)*Math.sin(dlon/2)
    c=2*Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d=radius*c*1000
    return d.floor#.to_s+"m"
  end

  def inside?(l1,l2,r)
    d=distance(l1,l2)
    if d<r
      output=true
    else
      output=false
    end
    return output
  end

  def where?(l1, locations, r)
    output=[]

    for j in 0..locations.length-1
      if inside?(l1, locations[j], r)==true
        output[output.length]=locations[j]
      elsif j==locations.length-1 and output.length==0
        output=false
      end
    end
    return output
  end

  module ConvexHul
    def self.calculate(points)
      lop = points.sort_by { |p| p.latitude }
      left = lop.shift
      right = lop.pop
      lower, upper = [left], [left]
      lower_hull, upper_hull = [], []
      det_func = determinant_function(left, right)
      until lop.empty?
        p = lop.shift
        ( det_func.call(p) < 0 ? lower : upper ) << p
      end
      lower << right
      until lower.empty?
        lower_hull << lower.shift
        while (lower_hull.size >= 3) &&
            !convex?(lower_hull.last(3), true)
          last = lower_hull.pop
          lower_hull.pop
          lower_hull << last
        end
      end
      upper << right
      until upper.empty?
        upper_hull << upper.shift
        while (upper_hull.size >= 3) &&
            !convex?(upper_hull.last(3), false)
          last = upper_hull.pop
          upper_hull.pop
          upper_hull << last
        end
      end
      upper_hull.shift
      upper_hull.pop
      lower_hull + upper_hull.reverse
    end

    private

    def self.determinant_function(p0, p1)
      proc { |p| ((p0.latitude-p1.latitude)*(p.longitude-p1.longitude))-((p.latitude-p1.latitude)*(p0.longitude-p1.longitude)) }
    end

    def self.convex?(list_of_three, lower)
      p0, p1, p2 = list_of_three
      (determinant_function(p0, p2).call(p1) > 0) ^ lower
    end

  end

end
