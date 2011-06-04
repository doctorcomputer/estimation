module ApplicationHelper
  def my_page_entries_info(collection, options = {})
    entry_name = options[:entry_name] ||
      (collection.empty?? 'entry' : collection.first.class.name.underscore.sub('_', ' '))

    #raw("#{entry_name.pluralize}: nessun elemento trovato.")
    #raw("<b>1</b> #{entry_name}")
    #raw("xxxDisplaying <b>all #{collection.size}</b> #{entry_name.pluralize}")
    if collection.total_pages < 2
      case collection.size
      when 0; raw("Nessun elemento trovato.")
      when 1; raw("1 elemento trovato.")
      else; raw("Tutti i #{collection.size} elementi trovati.")
      end
    else
      #%{Displaying #{entry_name.pluralize} <b>%d&nbsp;-&nbsp;%d</b> of <b>%d</b> in total}
      raw( %{Elementi %d - %d di %d in totale} % [
        collection.offset + 1,
        collection.offset + collection.length,
        collection.total_entries
      ])
    end
  end

  def titlize supposed_title
    unless supposed_title.nil?
      if supposed_title.size > 120
        supposed_title[0..40].capitalize + "..."
      else
        supposed_title.capitalize
      end
    else
      nil
    end
  end

end
