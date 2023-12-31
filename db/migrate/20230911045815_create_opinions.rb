class CreateOpinions < ActiveRecord::Migration[6.0]
  def change
    create_table :opinions do |t|
      t.string      :brand,       null: false
      t.integer     :privacy_id,  null: false
      t.text        :theory,      null: false
      t.references  :user,        null: false, foreign_key: true
      t.timestamps
    end
  end
end
