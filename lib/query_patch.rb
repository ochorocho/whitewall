module Whitewall
		module QueryPatch

			def available_columns_with_editor_id
				returning available_columns_without_editor_id do |columns|
					columns << QueryColumn.new(:editor_id,
																		 :caption => "editor",
																		 :sortable => "(SELECT journals.created_on FROM journals, journal_details WHERE journals.journalized_id = t0_r0 AND journals.id = journal_details.journal_id AND journal_details.prop_key = 'status_id' AND journal_details.property = 'attr' AND journal_details.value IN (SELECT is_close.id FROM issue_statuses is_close WHERE is_close.is_closed = 1) ORDER BY journals.created_on DESC LIMIT 1)"
					) unless columns.detect{ |c| c.name == :editor_id }
				end
			end

			def self.included(klass)
				klass.send :alias_method_chain, :available_columns, :editor_id
			end

		end
end
