module Whitewall
    module QueryPatch



	  def self.included(base) # :nodoc:
	    base.extend(ClassMethods)
	
	    base.send(:include, InstanceMethods)
	
	    # Same as typing in the class 
	    base.class_eval do
	      unloadable # Send unloadable so it will not be unloaded in development
	      base.add_available_column(QueryColumn.new(:deliverable_subject, :sortable => "#{Deliverable.table_name}.subject"))
	      
	      alias_method :redmine_available_filters, :available_filters
	      alias_method :available_filters, :budget_available_filters
	    end
	
	  end
	  
	  module ClassMethods
	    
	    # Setter for +available_columns+ that isn't provided by the core.
	    def available_columns=(v)
	      self.available_columns = (v)
	    end
	
	    # Method to add a column to the +available_columns+ that isn't provided by the core.
	    def add_available_column(column)
	      self.available_columns << (column)
	    end
	  end
	  
	  module InstanceMethods
	    
	    # Wrapper around the +available_filters+ to add a new Deliverable filter
	    def budget_available_filters
	      @available_filters = redmine_available_filters
	      
	      if project
	        budget_filters = { "deliverable_id" => { :type => :list_optional, :order => 14,
	            :values => Deliverable.find(:all, :conditions => ["project_id IN (?)", project], :order => 'subject ASC').collect { |d| [d.subject, d.id.to_s]}
	          }}
	      else
	        budget_filters = { }
	      end
	      return @available_filters.merge(budget_filters)
	    end
	  end  


	  ##############
	### KEINE AHNUNG WAS DAS MACHT
      ##############
#       def available_columns_with_spent_hours
#         returning available_columns_without_spent_hours do |columns|
#           if (project and User.current.allowed_to?(:view_time_entries, project)) or User.current.admin?
# 
#             columns << QueryColumn.new(:spent_hours, 
#               :caption => :label_spent_time, 
#               :sortable => "(select sum(hours) from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id)"
#             ) unless columns.detect{ |c| c.name == :spent_hours }
# 
#             columns << QueryColumn.new(:calculated_spent_hours,
#               :caption => :label_calculated_spent_hours,
#               :sortable => "(IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100)"
#             ) unless columns.detect{ |c| c.name == :calculated_spent_hours }
# 
#             columns << QueryColumn.new(:divergent_hours,
#               :caption => :label_divergent_hours,
#               :sortable => "((select sum(hours) from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id) - (IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100))"
#             ) unless columns.detect{ |c| c.name == :divergent_hours }
# 
#             columns << QueryColumn.new(:remaining_hours,
#               :caption => :label_remaining_hours,
#               :sortable => "(IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) - (IF(#{Issue.table_name}.estimated_hours IS NULL,0,#{Issue.table_name}.estimated_hours) * #{Issue.table_name}.done_ratio / 100))"
#             ) unless columns.detect{ |c| c.name == :remaining_hours }
# 
#           end
#         end
#       end

      def self.included(klass)
        klass.send :alias_method_chain, :available_columns, :spent_hours
      end
      
    end
end