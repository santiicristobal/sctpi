#require "./lib/polycon/helper/path"
require "date"
require "erb"
require "./lib/polycon/models/professional"
module Polycon
    module Models
        class Appointment
            def date_format(date)
                DateTime.parse(date).strftime("%F_%R")
            end

            def initialize(date, professional)
                @date= self.date_format(date)
                @professional= professional
            end

            def self.validate_date(date)
                begin
                    DateTime.parse(date)
                rescue
                    "Fecha incorrecta"
                end 
            end

            def professional
                @professional
            end

            def date
                @date
            end

            def appointment_rute (date, professional)
                Professional.new.professional_rute(professional)+"/#{date.gsub(" ", "_")}.paf"
            end

            def appointment_exist?(date, professional)
                File.exists?(self.appointment_rute(date, professional))
            end

            def self.appointment_exist?(date, professional)
                File.exists?(Appointment.appointment_rute(date, professional))
            end

            def self.appointment_rute (date, professional)
                Professional.new.professional_rute(professional)+"/#{date.gsub(" ", "_")}.paf"
            end

            def create (name, surname, phone, notes)
                a= File.open((self.appointment_rute(@date, @professional)), "w")
                a.puts("#{name}\n#{surname}\n#{phone}\n#{notes}")
                a.close
            end

            def self.reschedule (old_date, new_date, professional) 
                od= DateTime.parse(old_date).strftime("%F_%R")
                nd= DateTime.parse(new_date).strftime("%F_%R")
                File.rename(self.appointment_rute(od, professional),self.appointment_rute(nd, professional))
            end

            def cancel
                File.delete(self.appointment_rute(@date, @professional))
            end

            def self.cancelAll (professional)
                FileUtils.rm_rf(Dir.glob("#{Professional.new.professional_rute(professional)}/*"))
            end

            def self.list (professional)
                Dir.foreach(Professional.new.professional_rute(professional)).map {|p| 
                    if !File.directory? p 
                        DateTime.parse(p).strftime("%F %R")
                    end}.compact
            end

            def show
                File.read(self.appointment_rute(@date, @professional))
            end

            def edit(**options)
                data= File.readlines(self.appointment_rute(@date, @professional))
                options.each do |k, v|
                    case k.to_s
                        when "name"
                            data[0]= "#{v}"
                        when "surname"
                            data[1]= "#{v}"
                        when "phone"
                            data[2]= "#{v}"
                        when "notes"
                            data[3]= "#{v}"
                    end
                end
                aux= File.open((self.appointment_rute(@date, @professional)), "w")
                aux.puts(data)
                aux.close
            end

            def self.htmlday(date, professional)
                appo=Appointment.appointmentDay(date, professional)
                template= <<-ERB
                <!DOCTYPE html>
                <html>
                <head>
                    <title> Hola! </title>
                </head>
                <body>
                    <h1 align="center"> <%=DateTime.parse(date).strftime("%F")%> </h1>
                    <table align="center" border=1>
                        <tr>
                            <th> Professional </th>
                            <th> hour </th>
                        </tr>
                        <% appointments.each do |appointment| %>
                            <tr>
                                <td> <%= appointment.professional.gsub("_", " ") %> </td>
                                <td> <%= DateTime.parse(appointment.date).strftime("%R") %> </td>
                            </tr>
                        <% end %>
                    </table>
                </body>
                </html>
                ERB
                erb= ERB.new(template)
                output= erb.result_with_hash(appointments:appo, date:date)
                File.write(Dir.home+"/grilladay.html", output)
            end

            def self.appointmentDay(date, professional)
                if (professional.nil?)
                    arr2=[]
                    arr=Professional.listProfessional.to_a
                    arr.each do |p|
                        arr2=arr2+Appointment.appoDay(date, p)
                    end
                    arr2.to_a
                else
                    arr=Appointment.appoDay(date, professional)
                    arr.to_a
                end
            end

            def self.appoDay(date, professional)
                extend Rute
                l=Dir.foreach(self.professional_rute(professional)).select {|p| !File.directory? p}
                l.map {|p| 
                if (!File.directory? p) && (DateTime.parse(p).strftime("%F")==DateTime.parse(date).strftime("%F"))
                    Appointment.new(p, professional)
                end
                }.compact
            end
        end
    end
end

