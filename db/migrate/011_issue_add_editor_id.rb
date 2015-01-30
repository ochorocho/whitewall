class IssueAddEditorId < ActiveRecord::Migration
  def up
	add_column :issues, :editor_id, :integer
  end

  def down
	remove_column :issues, :editor_id
  end
end