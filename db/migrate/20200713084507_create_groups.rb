class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.references :leader, references: :user
      t.string :restaurant
      t.date :date

      t.timestamps
    end
  end
end
