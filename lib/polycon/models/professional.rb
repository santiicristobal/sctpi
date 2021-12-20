require "./lib/polycon/models/appointment"
module Polycon
    module Models
        class Professional
            def initialize(name)
                @professional=name
            end

            def name
                @professional
            end

            def self.polycon_exist?
                Dir.exists?(Dir.home+"/.polycon")
            end

            def self.professional_rute(professional)
                Dir.home+"/.polycon/#{professional.gsub(" ", "_")}"
            end

            def self.professional_exist?(professional)
                Dir.exists?(Professional.professional_rute(professional))
            end

            def create
                Dir.mkdir(Professional.professional_rute(@professional))
            end

            def delete
                Dir.delete(Professional.professional_rute(@professional))
            end

            def self.rename(old_name, new_name)
                File.rename(Professional.professional_rute(old_name),Professional.professional_rute(new_name))
            end

            def self.list
                Dir.foreach((Dir.home) +"/.polycon").map {|p| 
                if !File.directory? p
                    p.gsub("_"," ") 
                end}.compact
            end

            def self.listProfessional
                Dir.foreach((Dir.home) +"/.polycon").select {|p| !File.directory? p}
            end

            def data(date)
                appointment= Appointment.new(date, @professional)
                if (appointment.appointment_exist?(date, @professional))
                    "#{appointment.data_of_patient}"
                else
                    " Sin turno "
                end
            end

            def self.appointments_week?(professional, sunday)
                range = sunday..(sunday + 6)
                array = Professional.appointments(professional).select {|appointment| range.include?(DateTime.parse(appointment))}
                (array.size == 0)
            end

            def self.appointments(professional)
                Appointment.list(professional)
            end
        end
    end
end