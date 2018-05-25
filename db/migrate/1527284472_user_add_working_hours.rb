class UserAddWorkingHours < ActiveRecord::Migration
  def up
	  add_column :users, :working_hours, :integer
  end

  def down
	  remove_column :users, :working_hours
  end
end