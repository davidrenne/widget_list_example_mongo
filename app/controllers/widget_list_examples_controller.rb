class WidgetListExamplesController < ApplicationController

  def ruby_items

    #
    # Load Sample "items" Data. Comment out in your first time executing a widgetlist to create the items table
    #
=begin
    begin
      WidgetList::List.get_sequel.create_table :items do
        primary_key :id
        String :name
        Float :price
        Fixnum :sku
        String :active
        Date :date_added
      end
      items = WidgetList::List.get_sequel[:items]
      100.times {
        items.insert(:name => 'ab\'c_quoted_'    + rand(35).to_s,   :price => rand * 100, :date_added => '2008-02-01', :sku => rand(9999), :active => 'Yes')
        items.insert(:name => '12"3_'            + rand(35).to_s,   :price => rand * 100, :date_added => '2008-02-02', :sku => rand(9999), :active => 'Yes')
        items.insert(:name => 'asdf_'            + rand(35).to_s,   :price => rand * 100, :date_added => '2008-02-03', :sku => rand(9999), :active => 'Yes')
        items.insert(:name => 'qwerty_'          + rand(35).to_s,   :price => rand * 100, :date_added => '2008-02-04', :sku => rand(9999), :active => 'No')
        items.insert(:name => 'meow_'            + rand(35).to_s,   :price => rand * 100, :date_added => '2008-02-05', :sku => rand(9999), :active => 'No')
      }
    rescue Exception => e
      #
      # Table already exists
      #
      logger.info "Test table in items already exists? " + e.to_s
    end
=end

    begin

      list_parms   = WidgetList::List::init_config()

      #
      # Give it a name, some SQL to feed widget_list and set a noDataMessage
      #
      list_parms['name']          = 'ruby_items_yum'

      #
      # Handle Dynamic Filters
      #

      groupBy  = WidgetList::List::get_group_by_selection(list_parms)

      case groupBy
        when 'Item Name'
          groupByFilter                  = 'item'
          countSQL                       = 'COUNT(1) as cnt,'
          groupBySQL                     = 'GROUP BY name'
          groupByDesc                    = ' (Grouped By Name)'
        when 'Sku Number'
          groupByFilter                  = 'sku'
          countSQL                       = 'COUNT(1) as cnt,'
          groupBySQL                     = 'GROUP BY sku'
          groupByDesc                    = ' (Grouped By Sku Number)'
        else
          groupByFilter                  = 'none'
          countSQL                       = ''
          groupBySQL                     = ''
          groupByDesc                    = ''
      end

      list_parms['filter']    = []
      list_parms['bindVars']  = []
      drillDown, filterValue  = WidgetList::List::get_filter_and_drilldown(list_parms['name'])

      case drillDown
        when 'filter_by_name'
          list_parms['filter']   << " name = ? "
          list_parms['bindVars'] << filterValue
          list_parms['listDescription']   = WidgetList::List::drill_down_back(list_parms['name']) + ' Filtered by Name (' + filterValue + ')' + groupByDesc
        when 'filter_by_sku'
          list_parms['filter']   << " sku = ? "
          list_parms['bindVars'] << filterValue
          list_parms['listDescription']   = WidgetList::List::drill_down_back(list_parms['name']) + ' Filtered by SKU (' + filterValue + ')' + groupByDesc
        else
          list_parms['listDescription']   = ''
          list_parms['listDescription']   = WidgetList::List::drill_down_back(list_parms['name']) if !groupByDesc.empty?
          list_parms['listDescription']  += 'Showing All Ruby Items' + groupByDesc
      end

      # put <%= @output %> inside your view for initial load nothing to do here other than any custom concatenation of multiple lists
      #
      # Setup your first widget_list
      #

      button_column_name = 'actions'

      #
      # customFooter will add buttons to the bottom of the list.
      #

      list_parms['customFooter'] =  WidgetList::Widgets::widget_button('Add New Item', {'page' => '/add/'} ) + WidgetList::Widgets::widget_button('Do something else', {'page' => '/else/'} )

      #
      # Give some SQL to feed widget_list and set a noDataMessage
      #
      list_parms['searchIdCol']   = ['id','sku']

      #
      # Because sku_linked column is being used and the raw SKU is hidden, we need to make this available for searching via fields_hidden
      #
      list_parms['fieldsHidden'] = ['sku']
      drill_downs = []

      drill_downs << WidgetList::List::build_drill_down( :list_id                => list_parms['name'],
                                                         :drill_down_name        => 'filter_by_name',
                                                         :data_to_pass_from_view => (groupByFilter == 'none') ? 'a.name' : 'MAX(a.name)',
                                                         :column_to_show         => (groupByFilter == 'none') ? 'a.name' : 'MAX(a.name)',
                                                         :column_alias           => 'name_linked'
                                                       )

      drill_downs << WidgetList::List::build_drill_down(
                                                         :list_id                => list_parms['name'],
                                                         :drill_down_name        => 'filter_by_sku',
                                                         :data_to_pass_from_view => (groupByFilter == 'none') ? 'a.sku' : 'MAX(a.sku)',
                                                         :column_to_show         => (groupByFilter == 'none') ? 'a.sku' : 'MAX(a.sku)',
                                                         :column_alias           => 'sku_linked'
                                                       )

      if groupByFilter == 'none' || ['sqlite'].include?(WidgetList::List::get_db_type(false))
        list_parms['view']          = '(
                                       SELECT
                                             ' + countSQL + '
                                             ' + drill_downs.join(' , ') + ',
                                             \'\'     AS checkbox,
                                             a.id         AS id,
                                             a.active     AS active,
                                             a.name       AS name,
                                             a.sku        AS sku,
                                             a.price      AS price,
                                             a.date_added AS date_added
                                         FROM
                                             items a
                                       ' + groupBySQL + '
                                     ) a'
      else
        list_parms['view']          = '(
                                       SELECT
                                             ' + countSQL + '
                                             ' + drill_downs.join(' , ') + ',
                                             \'\'     AS checkbox,
                                             MAX(a.id)         AS id,
                                             MAX(a.active)     AS active,
                                             MAX(a.name)       AS name,
                                             MAX(a.sku)        AS sku,
                                             MAX(a.price)      AS price,
                                             MAX(a.date_added) AS date_added
                                         FROM
                                             items a
                                       ' + groupBySQL + '
                                     ) a'
      end
      #
      # Map out the visible fields
      #
      list_parms['fields'] = {}
      list_parms['fields']['checkbox']         = 'checkbox_header'
      list_parms['fields']['cnt']              = 'Total Items In Group'         if groupByFilter != 'none'
      list_parms['fields']['id']               = 'Item Id'                      if groupByFilter == 'none'
      list_parms['fields']['name_linked']      = 'Name'                         if groupByFilter == 'none' or groupByFilter == 'item'
      list_parms['fields']['price']            = 'Price of Item'                if groupByFilter == 'none'
      list_parms['fields']['sku_linked']       = 'Sku #'                        if groupByFilter == 'none' or groupByFilter == 'sku'
      list_parms['fields']['date_added']       = 'Date Added'                   if groupByFilter == 'none'
      list_parms['fields']['active']           = 'Active Item'                  if groupByFilter == 'none'
      list_parms['fields'][button_column_name] = button_column_name.capitalize  if groupByFilter == 'none'

      list_parms['noDataMessage'] = 'No Ruby Items Found'
      list_parms['title']         = 'Ruby Items Using Sequel!!!'

      #
      # Create small button array and pass to the buttons key
      #

      mini_buttons = {}
      mini_buttons['button_edit'] = {'page'       => '/edit',
                                     'text'       => 'Edit',
                                     'function'   => 'Redirect',
                                     #pass tags to pull from each column when building the URL
                                     'tags'       => {'my_key_name' => 'name','value_from_database'=>'price'}}

      mini_buttons['button_delete'] = {'page'       => '/delete',
                                       'text'       => 'Delete',
                                       'function'   => 'alert',
                                       'innerClass' => 'danger'}
      list_parms['buttons']                                            = {button_column_name => mini_buttons}

      list_parms['fieldFunction']                                      = {
        button_column_name => "''",
        'date_added'  => ['postgres','oracle'].include?(WidgetList::List::get_db_type(false)) ? "TO_CHAR(date_added, 'MM/DD/YYYY')" : "date_added"
      }

      list_parms['groupByItems']    = ['All Records', 'Item Name', 'Sku Number']


      #
      # Setup a custom field for checkboxes stored into the session and reloaded when refresh occurs
      #
      list_parms = WidgetList::List.checkbox_helper(list_parms,'id')

      list_parms.deep_merge!({'inputs' =>
                                {'checkbox'=>
                                   {'items' =>
                                      {
                                        'disabled_if'  => Proc.new { |row| row['ACTIVE'] == 'No' },
                                      }
                                   }
                                }
                             })
      #
      # Generate a template for the DOWN ARROW for CUSTOM FILTER
      #
      input = {}

      input['id']          = 'comments'
      input['name']        = 'comments'
      input['width']       = '170'
      input['max_length']  = '500'
      input['input_class'] = 'info-input'
      input['title']       = 'Optional CSV list'

      button_search = {}
      button_search['onclick']     = "alert('This would search, but is not coded.  That is for you to do')"

      list_parms['listSearchForm'] = WidgetList::Utils::fill( {
                                                                  '<!--BUTTON_SEARCH-->'       => WidgetList::Widgets::widget_button('Search', button_search),
                                                                  '<!--COMMENTS-->'            => WidgetList::Widgets::widget_input(input),
                                                                  '<!--BUTTON_CLOSE-->'        => "HideAdvancedSearch(this)" } ,
                                                                '
      <div id="advanced-search-container">
      <div class="widget-search-drilldown-close" onclick="<!--BUTTON_CLOSE-->">X</div>
        <ul class="advanced-search-container-inline" id="search_columns">
          <li>
             <div>Search Comments</div>
             <!--COMMENTS-->
          </li>
        </ul>
      <br/>
      <div style="text-align:right;width:100%;height:30px;" class="advanced-search-container-buttons"><!--BUTTON_RESET--><!--BUTTON_SEARCH--></div>
      </div>'
      # or to keep HTML out of controller render_to_string(:partial => 'partials/form_xxx')
      )

      #
      # Control widths of special fields
      #

      list_parms['columnWidth']    = {
        'date_added'=>'200px',
        'sku_linked'=>'20px',
      }

      #
      # If certain statuses of records are shown, visualize
      #

      list_parms.deep_merge!({'rowStylesByStatus' =>
                                {'active'=>
                                   {'Yes' => '' }
                                }
                             })
      list_parms.deep_merge!({'rowStylesByStatus' =>
                                {'active'=>
                                   {'No'  => 'font-style:italic;color:red;' }
                                }
                             })

      list_parms.deep_merge!({'rowColorByStatus' =>
                                {'active'=>
                                   {'Yes' => '' }
                                }
                             })
      list_parms.deep_merge!({'rowColorByStatus' =>
                                {'active'=>
                                   {'No'  => '#EBEBEB' }
                                }
                             })


      list_parms['columnPopupTitle'] = {}
      list_parms['columnPopupTitle']['checkbox']         = 'Select any record'
      list_parms['columnPopupTitle']['cnt']              = 'Total Count'
      list_parms['columnPopupTitle']['id']               = 'The primary key of the item'
      list_parms['columnPopupTitle']['name_linked']      = 'Name (Click to drill down)'
      list_parms['columnPopupTitle']['price']            = 'Price of item (not formatted)'
      list_parms['columnPopupTitle']['sku_linked']       = 'Sku # (Click to drill down)'
      list_parms['columnPopupTitle']['date_added']       = 'The date the item was added to the database'
      list_parms['columnPopupTitle']['active']           = 'Is the item active?'

      output_type, output  = WidgetList::List.build_list(list_parms)

      case output_type
        when 'html'
          # put <%= @output %> inside your view for initial load nothing to do here other than any custom concatenation of multiple lists
          @output = output
        when 'json'
          return render :inline => output
        when 'export'
          send_data(output, :filename => list_parms['name'] + '.csv')
          return
      end

    rescue Exception => e

      Rails.logger.info e.to_s + "\n\n" + $!.backtrace.join("\n\n")

      if Rails.env == 'development'
        list_parms['errors'] << "<br/><br/><strong style='color:maroon;'>(Ruby Exception - Still attempted to render list with given config #{list_parms.inspect}) Exception ==> \"#{e.to_s + "<br/><br/>Backtrace:<br/><br/>" + $!.backtrace.join("<br/><br/>")}\"</strong>"
      end

      #really this block is just to catch initial ruby errors in setting up your list_parms
      #I suggest taking out this rescue when going to production
      output_type, output  = WidgetList::List.build_list(list_parms)

      case output_type
        when 'html'
          @output = output
        when 'json'
          return render :inline => output
        when 'export'
          send_data(output, :filename => list_parms['name'] + '.csv')
          return
      end

    end
  end


  def administration
    @output = WidgetList.go!()
    return render :inline => @output if $_REQUEST.key?('ajax')
    return
  end


  def ruby_items_active_record
    begin

      list_parms   = WidgetList::List::init_config()

      #
      # Give it a name, some SQL to feed widget_list and set a noDataMessage
      #
      list_parms['database']      = 'secondary'
      list_parms['name']          = 'ruby_items_yum'

      #
      # Handle Dynamic Filters


      list_parms['filter']    = []
      list_parms['bindVars']  = []

      drillDown, filterValue  = WidgetList::List::get_filter_and_drilldown(list_parms['name'])

      case drillDown
        when 'filter_by_name'
          list_parms['filter']   << " name = ? "
          #
          # Since Sequel is not being used you must escape bindVars yourself!!
          #
          list_parms['bindVars'] << Item.sanitize(filterValue)
          list_parms['listDescription']   = WidgetList::List::drill_down_back(list_parms['name']) + ' Filtered by Name (' + filterValue + ')'
        when 'filter_by_sku'
          list_parms['filter']   << " sku = ? "
          list_parms['bindVars'] << Item.sanitize(filterValue)
          list_parms['listDescription']   = WidgetList::List::drill_down_back(list_parms['name']) + ' Filtered by SKU (' + filterValue + ')'
        else
          list_parms['listDescription']   = ''
          list_parms['listDescription']   = 'Showing All Ruby Items'
      end

      # put <%= @output %> inside your view for initial load nothing to do here other than any custom concatenation of multiple lists
      #
      # Setup your first widget_list
      #

      button_column_name = 'actions'

      #
      # customFooter will add buttons to the bottom of the list.
      #

      list_parms['customFooter'] =  WidgetList::Widgets::widget_button('Add New Item', {'page' => '/add/'} ) + WidgetList::Widgets::widget_button('Do something else', {'page' => '/else/'} )

      #
      # Give some SQL to feed widget_list and set a noDataMessage
      #
      list_parms['searchIdCol']   = ['id','sku']

      #
      # Because sku_linked column is being used and the raw SKU is hidden, we need to make this available for searching via fields_hidden
      #
      list_parms['fieldsHidden'] = {}
      list_parms['fieldsHidden']['sku']         = 'sku'
      list_parms['fieldsHidden']['date_added']  = 'date_added'
      list_parms['fieldsHidden']['name']        = 'name'

      #list_parms['view']   = Item

      #
      # Use Ransack advanced searching
      #
      list_parms['ransackSearch']  = Item.search(params[:q])
      list_parms['view']           = list_parms['ransackSearch'].result

      #
      # Group By
      #

      groupBy  = WidgetList::List::get_group_by_selection(list_parms)

      case groupBy
        when 'Averages And Sum'
          list_parms['groupBy']  = ''
          groupByFilter          = 'none'

        when 'Name'
          list_parms['groupBy']  = 'name'
          groupByFilter          = 'group_name'

        when 'Sku'
          list_parms['groupBy']  = 'sku'
          groupByFilter          = 'group_sku'

        else
          groupByFilter          = 'none'
          list_parms['groupBy']  = ''
      end

      if groupBy == 'Averages And Sum'
        list_parms['totalRow']['price']                = 'price'
        list_parms['totalRow']['sku_linked']           = 'sku_linked'
        list_parms['totalRowMethod']['price']          = 'average'
        list_parms['totalRowPrefix']['price']          = 'Average Price<br/>'
      end


      list_parms['groupByItems'] = ['All Items', 'Name', 'Sku','Averages And Sum']

      #
      # Fields
      #

      list_parms['fields']['id']                               =  'Id'                    if groupByFilter == 'none'
      list_parms['fields']['name_linked']                      =  'Name'                  if groupByFilter == 'none' || groupByFilter == 'group_name'
      list_parms['fields']['price']                            =  'Price'                 if groupByFilter == 'none'
      list_parms['fields']['sku_linked']                       =  'Sku'                   if groupByFilter == 'none' || groupByFilter == 'group_sku'
      list_parms['fields']['active']                           =  'Active'                if groupByFilter == 'none'
      list_parms['fields']['date_added']                       =  'Date Added'            if groupByFilter == 'none'
      list_parms['fields']['cnt']                              =  'Count'                 if groupByFilter != 'none'
      list_parms['fields'][button_column_name] = button_column_name.capitalize  if groupByFilter == 'none'

      #
      # price alert
      #
      list_parms['links']['price']                     = {
        'onclick' => 'alert',
        'tags' => {'price'=>'price'},
      }
      list_parms['columnStyle']['price']               = 'color:blue;'

      #
      # redirect with id/date_added replaced
      #
      list_parms['links']['id']                        = {
          'page' => '/my_page/id/date_added/',
          'tags' => {'all'=>'all'},
      }
      list_parms['columnStyle']['id']                  = 'color:blue;'

      #
      # multi-parameter
      #
      list_parms['links']['date_added']                = {
          'onclick' => 'alert_two',
          'tags' => {'price'=>'price','date_added'=>'date_added'},
      }
      list_parms['columnStyle']['date_added']          = 'color:blue;'
      
      
      list_parms['noDataMessage'] = 'No Ruby Items Found'
      list_parms['title']         = 'Ruby Items Using Active Record Models!!!'

      #
      # Create small button array and pass to the buttons key
      #

      mini_buttons = {}
      mini_buttons['button_edit'] = {'page'       => '/edit/id/',
                                     'text'       => 'Edit',
                                     'function'   => 'Redirect',
                                     #pass tags to pull from each column when building the URL
                                     'tags'       => {'all'=>'all'}}

      mini_buttons['button_delete'] = {'page'       => '/delete',
                                       'text'       => 'Delete',
                                       'function'   => 'alert',
                                       'innerClass' => 'danger'}
      list_parms['buttons']                                            = {button_column_name => mini_buttons}


      list_parms['fieldFunction']                                      = {
        button_column_name => "''",
        'date_added'  => ['postgres','oracle'].include?(WidgetList::List.get_db_type(true)) ? "TO_CHAR(date_added, 'MM/DD/YYYY')" : "date_added"
      }
      list_parms['fieldFunction']['cnt']                       =  'COUNT(1)'              if groupByFilter != 'none'

      list_parms['fieldFunction']['name_linked']    = WidgetList::List::build_drill_down( :list_id => list_parms['name'], :drill_down_name => 'filter_by_name', :data_to_pass_from_view => 'name', :column_to_show => 'name', :column_alias => 'name_linked',:primary_database => false,:link_color => 'maroon')
      list_parms['fieldFunction']['sku_linked']     = WidgetList::List::build_drill_down( :list_id => list_parms['name'], :drill_down_name => 'filter_by_sku', :data_to_pass_from_view => 'sku', :column_to_show => '\'Sku Numbers \' || sku', :column_alias => 'sku_linked',:primary_database => false,:link_color => 'maroon')
      list_parms['fieldFunction']['checkbox']       = '\'\''

      #
      # Setup a custom field for checkboxes stored into the session and reloaded when refresh occurs
      #
      list_parms = WidgetList::List.checkbox_helper(list_parms,'id')

      list_parms.deep_merge!({'inputs' =>
                                {'checkbox'=>
                                   {'items' =>
                                      {
                                        'disabled_if'  => Proc.new { |row| row['ACTIVE'] == 'No' },
                                      }
                                   }
                                }
                             })


      #
      # Control widths of special fields
      #

      list_parms['columnWidth']    = {
        'date_added'=>'200px',
        'sku_linked'=>'20px',
      }

      list_parms['columnPopupTitle'] = {}
      list_parms['columnPopupTitle']['checkbox']         = 'Select any record'
      list_parms['columnPopupTitle']['id']               = 'The primary key of the item'
      list_parms['columnPopupTitle']['name_linked']      = 'Name (Click to drill down)'
      list_parms['columnPopupTitle']['price']            = 'Price of item (not formatted)'
      list_parms['columnPopupTitle']['sku_linked']       = 'Sku # (Click to drill down)'
      list_parms['columnPopupTitle']['date_added']       = 'The date the item was added to the database'
      list_parms['columnPopupTitle']['active']           = 'Is the item active?'

      output_type, output  = WidgetList::List.build_list(list_parms)

      case output_type
        when 'html'
          # put <%= @output %> inside your view for initial load nothing to do here other than any custom concatenation of multiple lists
          @output = output
        when 'json'
          return render :inline => output
        when 'export'
          send_data(output, :filename => list_parms['name'] + '.csv')
          return
      end

    rescue Exception => e

      Rails.logger.info e.to_s + "\n\n" + $!.backtrace.join("\n\n")

      if Rails.env == 'development'
        list_parms['errors'] << "<br/><br/><strong style='color:maroon;'>(Ruby Exception - Still attempted to render list with given config #{list_parms.inspect}) Exception ==> \"#{e.to_s + "<br/><br/>Backtrace:<br/><br/>" + $!.backtrace.join("<br/><br/>")}\"</strong>"
      end

      #really this block is just to catch initial ruby errors in setting up your list_parms
      #I suggest taking out this rescue when going to production
      output_type, output  = WidgetList::List.build_list(list_parms)

      case output_type
        when 'html'
          @output = output
        when 'json'
          return render :inline => output
        when 'export'
          send_data(output, :filename => list_parms['name'] + '.csv')
          return
      end

    end


  end

end