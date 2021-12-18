class Appointment < ApplicationRecord
  belongs_to :professional
  validates :date, :name, :surname, :phone, :professional_id, presence: true
  validates :name, :surname, length: { maximum: 30 }
  validates :phone, numericality:{
    only_integer: true}
  validates_date :date, on_or_after: lambda {DateTime.tomorrow}, on_or_after_message: "Solicite un turno a partir de mañana"
  validates :date, uniqueness: {
    scope: :professional_id,
    message: "Este turno ya no esta disponible" } 
end
