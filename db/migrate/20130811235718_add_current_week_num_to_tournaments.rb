class AddCurrentWeekNumToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :current_week_num, :integer
  end
end
