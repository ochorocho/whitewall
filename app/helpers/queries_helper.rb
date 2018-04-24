module QueriesHelper
  def new_column_content(column, issue)
    value = column.value(issue)
    if value.class.name == "Float" and column.name == :spent_hours
      sprintf "%.2f", value
    else
      __column_content(column, issue)
    end
  end
  alias_method :__column_content, :column_content
  alias_method :column_content, :new_column_content
end