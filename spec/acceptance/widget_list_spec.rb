require 'acceptance/acceptance_helper'

feature 'Widget list', '' do 

  # 
  # Sequel/SqlLite
  #
  scenario 'Does index page for Sequel/SqlLite Example load?' do
    verify_index_works '/widget_list_examples/ruby_items/'
  end

  scenario 'Sequel/SqlLite Sorting Checks', :js => true do
    verify_sorting_works '/widget_list_examples/ruby_items/'
  end 

  scenario 'Sequel/SqlLite Paging and Limits', :js => true do
    verify_paging_works '/widget_list_examples/ruby_items/'
  end
 
  scenario 'Sequel/SqlLite Search', :js => true do
    verify_search_works '/widget_list_examples/ruby_items/'
  end

  scenario 'Sequel/SqlLite Group By Item Name', :js => true do
    visit '/widget_list_examples/ruby_items/'
    check_for_common_errors 
    find('.ruby_items_yum-group .widget-search-arrow').click
    find('#ruby_items_yum_row_2').click
    sleep(5)
    check_for_common_errors
    sort_click(['name_linked','cnt'])
  end 

  scenario 'Sequel/SqlLite Group By Sku', :js => true do
    visit '/widget_list_examples/ruby_items/'
    check_for_common_errors 
    find('.ruby_items_yum-group .widget-search-arrow').click
    find('#ruby_items_yum_row_3').click
    sleep(5)
    check_for_common_errors
    sort_click(['sku_linked','cnt'])
  end
 
  # 
  # ActiveRecord/Sqlite
  #
  scenario 'Does index page for ActiveRecord/Sqlite Example load?' do
    verify_index_works '/widget_list_examples/ruby_items_active_record/'
  end

  scenario 'ActiveRecord/Sqlite Sorting Checks', :js => true do
    verify_sorting_works '/widget_list_examples/ruby_items_active_record/'
  end 

  scenario 'ActiveRecord/Sqlite Paging and Limits', :js => true do
    verify_paging_works '/widget_list_examples/ruby_items_active_record/'
  end
 
  scenario 'ActiveRecord/Sqlite Search', :js => true do
    verify_search_works '/widget_list_examples/ruby_items_active_record/'
  end 
  

end
