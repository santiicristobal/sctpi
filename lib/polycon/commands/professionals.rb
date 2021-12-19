module Polycon
  module Commands
    module Professionals
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **)
          if Polycon::Models::Professional.polycon_exist?
            professional= Polycon::Models::Professional
            if professional.professional_exist?(name)
              warn "Este profesional ya existe"
            else
              professional.new(name).create
              puts "Profesional creado"
            end
          else
            warn "Se va a crear el directorio polycon, vuelva a ejecutar la operación que desea realizar"
            Dir.mkdir(Dir.home+"/.polycon")
          end
        end

      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name: nil)
          professional= Polycon::Models::Professional
          if professional.professional_exist?(name)
            professional.new(name).delete
            puts "Profesional borrado"  
          else
            warn "Este profesional no existe"
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          professional= Polycon::Models::Professional
          puts professional.list
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"',
        ]

        def call(old_name:, new_name:, **)
          professional= Polycon::Models::Professional
          if professional.professional_exist?(old_name)
            professional.rename(old_name, new_name)
            puts "Profesional Editado"  
          else
            warn "Este profesional no existe"
          end
        end
      end
    end
  end
end
