#require "./lib/polycon/helper/path"
module Polycon
    module Models
        class Professional
            def self.polycon_exist?
                Dir.exists?(Dir.home+"/.polycon")
            end

            def professional_rute(professional)
                Dir.home+"/.polycon/#{professional.gsub(" ", "_")}"
            end

            def professional_exist?(professional)
                Dir.exists?(self.professional_rute(professional))
            end

            def create(professional)
                Dir.mkdir(self.professional_rute(professional))
            end

            def delete(professional)
                Dir.delete(self.professional_rute(professional))
            end

            def rename(old_name, new_name)
                File.rename(self.professional_rute(old_name),self.professional_rute(new_name))
            end

            def list
                Dir.foreach((Dir.home) +"/.polycon").map {|p| 
                if !File.directory? p
                    p.gsub("_"," ") 
                end}.compact
            end

            def self.listProfessional
                Dir.foreach((Dir.home) +"/.polycon").select {|p| !File.directory? p}
            end
        end
    end
end