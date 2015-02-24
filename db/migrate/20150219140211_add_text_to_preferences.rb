class AddTextToPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :text, :string
  end
end
