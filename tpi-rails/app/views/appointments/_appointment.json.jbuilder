json.extract! appointment, :id, :date, :surname, :name, :phone, :notes, :professional_id, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
