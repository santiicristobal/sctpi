# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create( email: 'admin@gmail.com', password: '123456', password_confirmation: '123456', role: 0 )
User.create( email: 'consulta@gmail.com', password: '123456', password_confirmation: '123456', role: 1 )
User.create( email: 'asistencia@gmail.com', password: '123456', password_confirmation: '123456', role: 2 )

for i in 1..15 do
    professional= Professional.create(surname: "apellido_#{i}", name: "nombre_#{i}")
    for j in 1..5 do
        numero= rand(10000..20000)
        fecha= rand(DateTime.now..(DateTime.now+30))
        hora= rand(8..18)
        fecha= fecha.strftime("%F_#{hora}:00")
        fecha=DateTime.parse(fecha)
        Appointment.create( surname: "apellido_#{j}", name: "nombre_#{j}", phone: numero, professional_id: professional.id, date: fecha )
    end
end