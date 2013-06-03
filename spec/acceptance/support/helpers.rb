module HelperMethods
  #def wait_for_ajax
  #  wait_until(15) do
  #    page.evaluate_script('$.active') == 0
  #  end
  #end
  
  def verify_index_works(url)
    visit url
    check_for_common_errors
    check_count(500)
  end
  
  def verify_sorting_works(url)
    visit url
    check_for_common_errors
    sort_click(['name_linked','id','price','sku_linked','date_added','active'])
  end
  
  def verify_search_works(url)
    visit url
    check_for_common_errors
    fill_in 'list_search_id_ruby_items_yum', :with => 'qwerty'
    sleep(5)
    check_for_common_errors
  end
  
  def verify_paging_works(url)
    visit url
    check_for_common_errors
    find('#ruby_items_yum_per_page').find("option[4]").click
    sleep(5)
    page.should have_content("of 5 pages")
    check_for_common_errors
    find('#ruby_items_yum_next').click
    sleep(2)
    check_for_common_errors
    find('#ruby_items_yum_next').click
    sleep(2)
    check_for_common_errors
    find('#ruby_items_yum_next').click
    sleep(2)
    check_for_common_errors
    find('#ruby_items_yum_next').click
    sleep(2)
    check_for_common_errors
  end
  
  def verify_index_works(url)
    visit url
    check_for_common_errors
    check_count(500)
  end
  
  def check_for_common_errors
    page.should_not have_content("An error occurred")
    page.should_not have_content("Application Trace")
    page.should_not have_content("Currently no data")
    page.should_not have_content("No Ruby Items Found")
    page.should_not have_content("Ruby Exception")
  end
  
  def back
    page.evaluate_script('window.history.back()')
  end
  
  def check_count(count)
    page.should have_content("Total " + count.to_s + " records found")
  end
  
  def sort_click(columns=[])
    columns.each {|col|
      #ascending
      find('#' + col+ ' span').click
      sleep(5)
      check_for_common_errors 
      
      #descending
      find('#' + col+ ' span').click
      sleep(5)
      check_for_common_errors 
    }
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance