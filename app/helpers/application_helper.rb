module ApplicationHelper
     def bootstrap_flash_class(flash_type)
          case flash_type.to_sym
          when :notice then "info"
          when :alert then "danger"
          when :success then "success"
          else "secondary"
          end
     end

     def sortable(column, title = nil)
          title ||= column.titleize
          direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
          link_to title, { sort: column, direction:, search: params[:search] }, class: "sortable"
     end
end
