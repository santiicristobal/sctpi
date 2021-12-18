require "./lib/polycon/models/appointment"
require "./lib/polycon/models/professional"

module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          begin
            Polycon::Models::Appointment.validate_date(date)
            appointment= Polycon::Models::Appointment.new(date, professional) 
            prof= Polycon::Models::Professional.new()
            if prof.professional_exist?(professional) && !appointment.appointment_exist?(date, professional) && (DateTime.parse(date) > DateTime.now)
              appointment.create(name, surname, phone, notes)
              puts "Turno creado con exito"
            elsif DateTime.parse(date) <= DateTime.now
              warn "La fecha ingresada es vieja"
            elsif appointment.appointment_exist?(date, professional)
              warn "El turno ya existe"
            else
              warn "El profesional no existe, el turno no fue creado"
            end
          rescue
            warn "La fecha debe tener el formato AAAA-MM-DD_HH-II" 
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          begin
            Polycon::Models::Appointment.validate_date(date)
            appointment= Polycon::Models::Appointment.new(date, professional) 
            prof= Polycon::Models::Professional.new()
            if prof.professional_exist?(professional) && appointment.appointment_exist?(date, professional)
              puts appointment.show()
            elsif !appointment.appointment_exist?(date, professional) && prof.professional_exist?(professional)
              warn "No hay turnos con ese profesional"
            else
              warn "No existe el profesional"
            end
          rescue
            warn "La fecha debe tener el formato AAAA-MM-DD_HH-II"
          end
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          begin 
            Polycon::Models::Appointment.validate_date(date)
            appointment= Polycon::Models::Appointment.new(date, professional) 
            prof= Polycon::Models::Professional.new()
            if prof.professional_exist?(professional) && appointment.appointment_exist?(date, professional)
              appointment.cancel
              puts "Turno eliminado con exito"
            elsif !appointment.appointment_exist?(date, professional) && prof.professional_exist?(professional)
              warn "Ese turno no existe con ese profesional"
            else
              warn "No existe ese profesional"
            end
          rescue
            warn "La fecha debe tener el formato AAAA-MM-DD_HH-II"
          end
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)
          appointment= Polycon::Models::Appointment
          prof= Polycon::Models::Professional.new()
          if prof.professional_exist?(professional)
            appointment.cancelAll(professional)
            puts "Todos los turnos se eliminaron con exito"
          else
            warn "No existe ese profesional"
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:)
          appointment= Polycon::Models::Appointment
          prof= Polycon::Models::Professional.new()
          if prof.professional_exist?(professional) 
            puts appointment.list(professional)
          elsif
            warn "No existe ese profesional"
          end
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          begin
            Polycon::Models::Appointment.validate_date(old_date)
            Polycon::Models::Appointment.validate_date(new_date)
            appointment= Polycon::Models::Appointment
            prof= Polycon::Models::Professional.new()
            if prof.professional_exist?(professional) && appointment.appointment_exist?(old_date, professional) && (DateTime.parse(new_date) > DateTime.now)
              appointment.reschedule(old_date, new_date, professional)
              puts "Modificacion realizada con exito"
            elsif DateTime.parse(new_date) <= DateTime.now
              warn "La nueva fecha ingresada es vieja"
            elsif prof.professional_exist?(professional) && !appointment.appointment_exist?(old_date, professional)
              warn "No existe ese turno"
            else
              warn "No existe el profesional"
            end
          rescue
            warn "La fecha debe tener el formato AAAA-MM-DD_HH-II"  
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.',
        ]

        def call(date:, professional:, **options)
          begin
            Polycon::Models::Appointment.validate_date(date)
            appointment= Polycon::Models::Appointment.new(date, professional)
            prof= Polycon::Models::Professional.new()
            if prof.professional_exist?(professional) && appointment.appointment_exist?(date, professional)
              appointment.edit(**options)
              puts "Editado con exito"
            elsif prof.professional_exist?(professional) && !appointment.appointment_exist?(date, professional)
              warn "No existe el turno"
            else
              warn "No existe ese profesional"
            end
          rescue
            warn "La fecha debe tener el formato AAAA-MM-DD_HH-II"  
          end
        end
      end
      class Commandsgrilla < Dry::CLI::Command
        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: false, desc: 'Full name of the professional'

        def call(date:, professional: nil)
          appointment= Polycon::Models::Appointment
          prof= Polycon::Models::Professional.new()
          if !profesional.nil? 
            if prof.professional_exist?(professional)
              appointment.htmlday(date, professional)
            else
              warn "No existe ese profesional"
            end
          else
            appointment.htmlday(date, professional)
          end
        end
      end
    end
  end
end
