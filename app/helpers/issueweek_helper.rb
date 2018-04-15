# encoding: utf-8
#
# Redmine Plugin - Whitewall
# Copyright (C) 2018  Jochen Roth
#

require 'redmine/utils'
include Redmine::Utils::DateCalculation

module IssueweekHelper

  def user_week_issue(user,week,year)
    if week[0].to_f == '53'
      calWeek = week
      calYear = year
    else
      calWeek = week
      calYear = year
    end

    weekBegin = Date.commercial(calYear, calWeek, 1)
    weekEnd = Date.commercial(calYear, calWeek, 7)

    @issues = Issue.where("editor_id = ? AND ((start_date BETWEEN ? AND ?) OR (due_date BETWEEN ? AND ?) OR (start_date <= ? AND due_date >= ?))", user.id, weekBegin, weekEnd, weekBegin, weekEnd, weekBegin, weekEnd)
    return @issues

  end

  def user_week_issues_delayed(user,week,year)
    @issues = user_week_issue(user,week,year)

    @delayed = []
    @issues.each do |issue|

      if issue.due_date < Date.today
        @delayed << issue
      end
    end

    return @delayed
  end

    def user_week_estimated_hours(user,week,year)
    # ESTIMATED HOURS
    @issues = user_week_issue(user,week,year)
    @estimated = 0
    @issues.each do |issue|

      if issue.due_date.blank? || issue.start_date.blank? || issue.estimated_hours.blank?
        @estimated += 0
      else

        if issue.start_date < Date.today && issue.due_date > Date.today
          @dayRest = Date.today
        else
          @dayRest = issue.start_date
        end

        # TODO: Wenn Startdatum über aktuellem Datum
        # TODO: Feiertage ermitteln und auslassen (was macht working_days)
        @workDaysTotal = (working_days(issue.start_date, issue.due_date) + 1) ### + 1 Für richtiges Ergebnis

        @hoursPerDay = ((issue.estimated_hours - (issue.estimated_hours * issue.done_ratio / 100)) / @workDaysTotal).round(2)

        @hoursPerWeek = 0

        # START WEEK
        if(@dayRest.strftime("%U").to_i + 1) == week[0].to_i
          puts "BEGINNING WEEK"
          @hoursPerWeek = (issue['hourPerDay'] * (@dayRest.end_of_week.to_date - (@dayRest.to_date + 1)).to_f)
        end

        # END WEEK
        if(issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
          puts "BEGINNING WEEK"
          @hoursPerWeek =  (issue['hourPerDay'] * ((issue.due_date.to_date + 1) - issue.due_date.beginning_of_week.to_date).to_f)
        end

        # START / STOP IN SAME WEEK
        if(@dayRest.strftime("%U").to_i + 1) == week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
          puts = "START STOP IN SAME WEEK"
          @hoursPerWeek = (issue.estimated_hours - (issue.estimated_hours * issue.done_ratio / 100)).to_f
        end

        # NEITHER START NOR STOP DATE - FULL WEEK!
        if (@dayRest.strftime("%U").to_i + 1) != week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) != week[0].to_i
          puts = "MIDDLE WEEK - WEEK IS A I AM"
          @hoursPerWeek = @hoursPerDay * 5
        end

        if issue.children.count == 0
          @estimated += @hoursPerWeek
        end

      end
    end

    # return @estimated.round(2)
    return @estimated

  end

end
