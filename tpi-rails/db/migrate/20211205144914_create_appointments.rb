class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.datetime :date
      t.string :surname
      t.string :name
      t.integer :phone
      t.string :notes
      t.belongs_to :professional, null: false, foreign_key: true

      t.timestamps
    end
  end
end
