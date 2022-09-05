class MeasurementsController < ApplicationController
  before_action :set_measurement, only: [:edit, :update, :destroy]

  # GET /measurements
  # GET /measurements.json
  def index
    @measurements = Measurement.all.order('date DESC').order('time DESC')
  end

  # GET /measurements/new
  def new
    @title = "New Measurement"
    @measurement = Measurement.new
  end

  # GET /measurements/1/edit
  def edit
    @title = "Edit Measurement"
  end

  # POST /measurements
  # POST /measurements.json
  def create
    @measurement = Measurement.new(measurement_params)

    respond_to do |format|
      if @measurement.save
        format.html { redirect_to measurements_path, notice: 'Measurement was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /measurements/1
  # PATCH/PUT /measurements/1.json
  def update
    respond_to do |format|
      if @measurement.update(measurement_params)
        format.html { redirect_to measurements_path, notice: 'Measurement was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /measurements/1
  # DELETE /measurements/1.json
  def destroy
    @measurement.destroy
    respond_to do |format|
      format.html { redirect_to measurements_url, notice: 'Measurement was successfully destroyed.' }
    end
  end

  protected

  def setTitle
    @title = "Measurements"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measurement
      @measurement = Measurement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def measurement_params
      params.require(:measurement).permit(:date, :time, :weight, :waist_extended, :waist_normal, :hip, :chest, :bicep, :forearm, :calves, :thighs)
    end
end
