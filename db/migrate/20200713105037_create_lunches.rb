class CreateLunches < ActiveRecord::Migration[6.0]
  def change
    create_table :lunches do |t|
      t.string :status, default: 'pending'
      t.date :date
      t.references :user, null: false, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
