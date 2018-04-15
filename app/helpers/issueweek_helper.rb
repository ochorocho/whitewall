# encoding: utf-8
#
# Redmine Plugin - Whitewall
# Copyright (C) 2018  Jochen Roth
#

require 'redmine/utils'

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

  def user_week_estimated_hours(user,week,year,issues)

    # ESTIMATED HOURS
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
        #@workDaysTotal = (working_days(10, issue.due_date) + 1) ### + 1 Für richtiges Ergebnis
        #issue.daysTotal = @workDaysTotal
        #issue.hourPerDay = ((issue.estimated_hours - (issue.estimated_hours * issue.done_ratio / 100)) / @workDaysTotal).round(2)

        # issue.hourPerWeek = 0

        # # START WEEK
        # if(@dayRest.strftime("%U").to_i + 1) == week[0].to_i
        #   issue['whereAmI'] = "BEGINNING WEEK"
        #   issue['hourPerWeek'] = (issue['hourPerDay'] * (@dayRest.end_of_week.to_date - (@dayRest.to_date + 1)).to_f)
        # end
        #
        # # END WEEK
        # if(issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
        #   issue['whereAmI'] = "ENDING WEEK"
        #   issue['hourPerWeek'] =  (issue['hourPerDay'] * ((issue.due_date.to_date + 1) - issue.due_date.beginning_of_week.to_date).to_f)
        # end
        #
        # # START / STOP IN SAME WEEK
        # if(@dayRest.strftime("%U").to_i + 1) == week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
        #   issue['whereAmI'] = "START STOP IN SAME WEEK"
        #   issue['hourPerWeek'] = (issue.estimated_hours - (issue.estimated_hours * issue.done_ratio / 100)).to_f
        # end
        #
        # # NEITHER START NOR STOP DATE - FULL WEEK!
        # if (@dayRest.strftime("%U").to_i + 1) != week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) != week[0].to_i
        #   issue['whereAmI'] = "MIDDLE WEEK - WEEK IS A I AM"
        #   issue['hourPerWeek'] = issue['hourPerDay'] * 5
        # end
        #
        #
        # # WEEK IS IN THE PAST, yey
        # issue['showHours'] = 0
        # if(Date.today.strftime("%U").to_i + 1) <= week[0].to_i
        #   issue['showHours'] = 1
        # end
        #
        # if issue.children.count == 0
        #   @estimated += issue['hourPerWeek']
        # end

      end
    end

    # return @estimated.round(2)
    return 2

  end

end
