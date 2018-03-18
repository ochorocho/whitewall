# encoding: utf-8
#
# Redmine Plugin - Whitewall
# Copyright (C) 2018  Jochen Roth
#
module IssueweekHelper
  def user_week_issue(user,week,year)
    if week[0].to_f == '53'
      calWeek = week.to_i
      calYear = year.to_i
    else
      calWeek = week.to_i
      calYear = year.to_i
    end

    weekBegin = Date.commercial(calYear, calWeek, 1)
    weekEnd = Date.commercial(calYear, calWeek, 7)

    @issues = Issue.where("editor_id = ? AND ((start_date BETWEEN ? AND ?) OR (due_date BETWEEN ? AND ?) OR (start_date <= ? AND due_date >= ?))", user.id, weekBegin, weekEnd, weekBegin, weekEnd, weekBegin, weekEnd)
    return @issues

  end

end
