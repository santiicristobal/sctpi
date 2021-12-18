class CreateProfessionals < ActiveRecord::Migration[6.1]
  def change
    create_table :professionals do |t|
      t.string :surname
      t.string :name

      t.timestamps
    end
  end
end
