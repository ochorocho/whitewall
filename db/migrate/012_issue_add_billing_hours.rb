class IssueAddBillingHours < ActiveRecord::Migration
  def up
	add_column :issues, :billing_hours, :float
  end

  def down
	remove_column :issues, :billing_hours
  end
end