class Professional < ApplicationRecord
    has_many :appointments
    validates :name, :surname, presence: true, length: { maximum: 30 }
    validates :name, uniqueness: {
        scope: :surname,
        message: "Ya existe este profesional" }
        
    def grilla(date)
        turno= self.appointments.select{ | appointment | appointment.date==date }.first
        if turno.nil?
            "No hay turno"
        else
            "#{turno.surname} #{turno.name}"
        end
    end
end
