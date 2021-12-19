class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show edit update destroy ]
  before_action :set_professional, only: %i[ show edit update destroy destroy_all index new create ]
  before_action :week_calendar, only: %i[ grilla_week ]
  # GET /appointments or /appointments.json
  def index
    @appointments = Professional.find(params[:professional_id]).appointments.reorder('date')
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to professional_appointments_path(@professional.id), notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to professional_appointments_path(@professional), notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to professional_appointments_path(@professional.id), notice: "Appointment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def destroy_all
    Appointment.where(professional_id: @professional.id).destroy_all
    respond_to do |format|
      format.html { redirect_to professional_appointments_path(@professional.id), notice: "Los turnos han sido cancelado." }
      format.json { head :no_content }
    end
  end

  def grilla_day
    erb= ERB.new(File.read("./app/views/appointments/grilla_day.html.erb"))
    date= DateTime.parse("#{(params["date(1i)".to_sym])}-#{(params["date(2i)".to_sym])}-#{(params["date(3i)".to_sym])}_08:00")
    dateEnd= DateTime.parse(date.strftime("%F_18:00"))
    if (params[:professional_id]) == ""
      appointments= Appointment.where('date BETWEEN ? AND ?', date, dateEnd).reorder('date')
      output= erb.result_with_hash(appointments:appointments, date:date, professional:nil)
    title= "#{date.strftime("%F")}.html"
    else
      professional= Professional.find(params[:professional_id])
      appointments= professional.appointments.where('date BETWEEN ? AND ?', date, dateEnd).reorder('date')
      output= erb.result_with_hash(appointments:appointments, date:date, professional:professional)
      title= "#{professional.surname}-#{professional.name}-#{date.strftime("%F")}.html"
    end  
    send_data(output, :filename =>title)
  end

  def grilla_week
    erb= ERB.new(File.read("./app/views/appointments/grilla_week.html.erb"))
    if (params[:professional_id]) == ""
      professionals= Professional.joins(:appointments).where('appointments.date BETWEEN ? AND ?', (@date), (@dateEnd)).group('professionals.id')
      output= erb.result_with_hash(professionals:professionals, date:@date, professional:nil)
      title= "week-#{@date.strftime("%F")}.html"
    else
      professional= Professional.find(params[:professional_id])
      professionals= [professional]
      output= erb.result_with_hash(professionals:professionals, date:@date, professional:professional)  
      title= "#{professional.surname}-#{professional.name}-week-#{@date.strftime("%F")}.html"
    end
    send_data(output, :filename =>title)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:date, :surname, :name, :phone, :notes, :professional_id)
    end

    def set_professional
      @professional = Professional.find(params[:professional_id])  
    end

    def week_calendar
      @date = DateTime.parse("#{(params["date(1i)".to_sym])}-#{(params["date(2i)".to_sym])}-#{(params["date(3i)".to_sym])}_08:00")  
      case @date.strftime("%A")
        when "Sunday"
          @date
        when "Monday"
          @date= @date-1
        when "Tuesday"
          @date= @date-2
        when "Wednesday"
          @date= @date-3
        when "Thursday"
          @date= @date-4
        when "Friday"
          @date= @date-5
        when "Saturday"
          @date= @date-6
      end
      @dateEnd= @date + 6
      @dateEnd= DateTime.parse(@dateEnd.strftime("%F_18:00"))
    end
end
