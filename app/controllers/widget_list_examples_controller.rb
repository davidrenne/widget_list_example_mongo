class WidgetListExamplesController < ApplicationController

  def administration
    @output = WidgetList.go!()
    return render :inline => @output if $_REQUEST.key?('ajax')
    return
  end

  def ruby_items
    begin


      button_column_name              = 'Actions'
      groupByDesc                     = ''     # Initialize a variable you can use in listDescription to show what the current grouping selection is
      groupByFilter                   = 'none' # This variable should be used to control business logic based on the grouping and is a short hand key rather than using what is returned from get_group_by_selection


      list_parms                      = WidgetList::List::init_config()

      #list_parms = WidgetList::List.where(list_parms,'name','meow_22')
      #list_parms = WidgetList::List.where(list_parms,'sku','4833','>=')
      #list_parms = WidgetList::List.where(list_parms,'date_added','2008-02-05,2008-02-01','in')
      #list_parms = WidgetList::List.where(list_parms,'name','qwerty_9,qwerty_8','in')

      list_parms['name']              = 'item_listing'
      list_parms['noDataMessage']     = 'No Items Found Within Your Criteria'
      list_parms['rowLimit']          = 10
      list_parms['title']             = 'Items (Auto Generated from Admin Console)'
      list_parms['useSort']           = true
      list_parms['showPagination']    = true
      list_parms['database']          = 'primary'
      list_parms['showExport']        = true
      list_parms['exportButtonTitle'] = 'Export All Items'
      list_parms['searchTitle']       = 'Search by Id or CSV of Ids and more'


      list_parms['listDescription']   = 'Showing All Items'


      #
      # Group By
      #

      groupBy  = WidgetList::List::get_group_by_selection(list_parms)

      case groupBy
        when 'All Items'
          list_parms['groupBy']  = ''
          groupByFilter          = 'none'
          groupByDesc            = ''

        when 'Date'
          list_parms['groupBy']  = 'date_added'
          groupByFilter          = 'group_date'
          groupByDesc            = ' (Grouped By DateAdded)'

        when 'Sku'
          list_parms['groupBy']  = 'sku'
          groupByFilter          = 'group_sku'
          groupByDesc            = ' (Grouped By Sku)'

        when 'Active'
          list_parms['groupBy']  = 'active'
          groupByFilter          = 'group_active'
          groupByDesc            = ' (Grouped By Active)'

        else
          list_parms['groupBy']  = ''
      end

      list_parms['groupByItems'] = ['All Items', 'Date', 'Sku', 'Active']

      #
      # Fields
      #

      list_parms['fields']['checkbox']                         =  'checkbox_header'      if groupByFilter == 'none'
      list_parms['fields']['price']                            =  'Price'                 if groupByFilter == 'none'
      list_parms['fields']['date_added']                       =  'Date Added'            if groupByFilter == 'none' || groupByFilter == 'group_date'
      list_parms['fields']['sku']                              =  'Sku'                   if groupByFilter == 'none' || groupByFilter == 'group_sku'
      list_parms['fields']['active']                           =  'Active'                if groupByFilter == 'none' || groupByFilter == 'group_active'
      list_parms['fields']['cnt']                              =  'Count'                 if groupByFilter != 'none'

      list_parms['fields'][button_column_name.downcase]        =  button_column_name.capitalize if groupByFilter == 'none'

      list_parms['fieldsHidden'] << '_id'

      list_parms['fieldFunction']['cnt']                       =  'COUNT(1)'              if groupByFilter != 'none'
      list_parms['fieldFunction'][button_column_name.downcase] = "''"
      list_parms['fieldFunction']['checkbox']                  =  "''"



      #
      # Model
      #

      list_parms['view']                                       =  Item



      list_parms = WidgetList::List.checkbox_helper(list_parms,'_id')


      #
      # Buttons
      #
      mini_buttons = {}

      mini_buttons['button_edit'] = {'page'       => '/widget_list_examples/edit/id/',
                                     'text'       => 'Edit',
                                     'function'   => 'Redirect',
                                     'innerClass' => 'info',
                                     'tags'       => {'all'=>'all'}
      }

      mini_buttons['button_delete'] = {'page'       => '/widget_list_examples/delete/id/',
                                       'text'       => 'Delete',
                                       'function'   => 'Redirect',
                                       'innerClass' => 'danger',
                                       'tags'       => {'all'=>'all'}
      }

      list_parms['buttons']       = {button_column_name.downcase => mini_buttons}


      #
      # Render List
      #
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

    rescue Exception => e

      #
      # Rescue Errors
      #
      Rails.logger.info e.to_s + "\n\n" + $!.backtrace.join("\n\n")

      if Rails.env == 'development'
        list_parms['errors'] << '<br/><br/><strong style="color:maroon;">(Ruby Exception - Still attempted to render list with given config ' + list_parms.inspect + ') Exception ==> ' + e.to_s + "<br/><br/>Backtrace:<br/><br/>" + $!.backtrace.join("<br/><br/>") + "</strong>"
      end

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
return
  end


  def ruby_items_active_record

=begin
/** items indexes **/
db.getCollection("items").ensureIndex({
  "_id": NumberInt(1)
},[

]);

/** items records **/
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000001"),
  "price": 24.2713582319,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(6701),
  "active": "Yes",
  "name": "ab'c_quoted_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000002"),
  "price": 38.5489155359,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(2513),
  "active": "Yes",
  "name": "12\"3_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000003"),
  "price": 28.2009071858,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4853),
  "active": "Yes",
  "name": "asdf_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000004"),
  "price": 3.41535310785,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4393),
  "active": "No",
  "name": "qwerty_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000005"),
  "price": 61.7181976051,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(5856),
  "active": "No",
  "name": "meow_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000006"),
  "price": 21.2332339414,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7140),
  "active": "Yes",
  "name": "ab'c_quoted_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000007"),
  "price": 99.5109330722,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(2785),
  "active": "Yes",
  "name": "12\"3_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000008"),
  "price": 23.930410875,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(7660),
  "active": "Yes",
  "name": "asdf_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000009"),
  "price": 5.18629615413,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(1256),
  "active": "No",
  "name": "qwerty_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e200000a"),
  "price": 28.2046932615,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1543),
  "active": "No",
  "name": "meow_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e200000b"),
  "price": 80.8859452551,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(9140),
  "active": "Yes",
  "name": "ab'c_quoted_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e200000c"),
  "price": 26.8694052161,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4677),
  "active": "Yes",
  "name": "12\"3_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e200000d"),
  "price": 46.3958293721,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6085),
  "active": "Yes",
  "name": "asdf_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e200000e"),
  "price": 30.1497513437,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8678),
  "active": "No",
  "name": "qwerty_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e200000f"),
  "price": 24.8606435036,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(7150),
  "active": "No",
  "name": "meow_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000010"),
  "price": 1.85114658418,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7912),
  "active": "Yes",
  "name": "ab'c_quoted_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000011"),
  "price": 83.8683487921,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4523),
  "active": "Yes",
  "name": "12\"3_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000012"),
  "price": 58.9895523157,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6758),
  "active": "Yes",
  "name": "asdf_17"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000013"),
  "price": 66.0150206744,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(103),
  "active": "No",
  "name": "qwerty_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1727e13064e2000014"),
  "price": 88.3744532681,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(9537),
  "active": "No",
  "name": "meow_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1827e13064e2000015"),
  "price": 44.6103594356,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7508),
  "active": "Yes",
  "name": "ab'c_quoted_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1827e13064e2000016"),
  "price": 56.9702589107,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(7636),
  "active": "Yes",
  "name": "12\"3_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1827e13064e2000017"),
  "price": 97.502145134,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4418),
  "active": "Yes",
  "name": "asdf_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1827e13064e2000018"),
  "price": 39.2377935477,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(6269),
  "active": "No",
  "name": "qwerty_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1827e13064e2000019"),
  "price": 20.4419533829,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1373),
  "active": "No",
  "name": "meow_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1827e13064e200001a"),
  "price": 65.8017384758,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(4882),
  "active": "Yes",
  "name": "ab'c_quoted_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1827e13064e200001b"),
  "price": 66.7080316406,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5768),
  "active": "Yes",
  "name": "12\"3_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200001c"),
  "price": 21.9911230404,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1524),
  "active": "Yes",
  "name": "asdf_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200001d"),
  "price": 49.7890487632,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(940),
  "active": "No",
  "name": "qwerty_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200001e"),
  "price": 44.2010785845,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(3638),
  "active": "No",
  "name": "meow_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200001f"),
  "price": 70.4150794217,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(3937),
  "active": "Yes",
  "name": "ab'c_quoted_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000020"),
  "price": 1.47425229759,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5899),
  "active": "Yes",
  "name": "12\"3_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000021"),
  "price": 24.944925503,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(145),
  "active": "Yes",
  "name": "asdf_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000022"),
  "price": 76.9637161899,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8552),
  "active": "No",
  "name": "qwerty_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000023"),
  "price": 10.9888099907,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4867),
  "active": "No",
  "name": "meow_5"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000024"),
  "price": 96.6247535688,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(4666),
  "active": "Yes",
  "name": "ab'c_quoted_5"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000025"),
  "price": 54.9253963978,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(1674),
  "active": "Yes",
  "name": "12\"3_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000026"),
  "price": 56.7117784224,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(2827),
  "active": "Yes",
  "name": "asdf_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000027"),
  "price": 19.6143482934,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5139),
  "active": "No",
  "name": "qwerty_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000028"),
  "price": 37.983168551,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(5996),
  "active": "No",
  "name": "meow_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000029"),
  "price": 39.4535441609,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7118),
  "active": "Yes",
  "name": "ab'c_quoted_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200002a"),
  "price": 99.8573522091,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3312),
  "active": "Yes",
  "name": "12\"3_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200002b"),
  "price": 86.156581448,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4243),
  "active": "Yes",
  "name": "asdf_2"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200002c"),
  "price": 60.2925944178,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(955),
  "active": "No",
  "name": "qwerty_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200002d"),
  "price": 46.0402015602,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1360),
  "active": "No",
  "name": "meow_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200002e"),
  "price": 59.8230436534,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(8969),
  "active": "Yes",
  "name": "ab'c_quoted_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200002f"),
  "price": 77.7664718505,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(2175),
  "active": "Yes",
  "name": "12\"3_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000030"),
  "price": 12.3053880312,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1634),
  "active": "Yes",
  "name": "asdf_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000031"),
  "price": 99.8166519777,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(831),
  "active": "No",
  "name": "qwerty_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000032"),
  "price": 76.4876756372,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(7977),
  "active": "No",
  "name": "meow_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000033"),
  "price": 51.4362866241,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(4527),
  "active": "Yes",
  "name": "ab'c_quoted_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000034"),
  "price": 31.1079488859,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(2770),
  "active": "Yes",
  "name": "12\"3_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000035"),
  "price": 24.1856161201,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1722),
  "active": "Yes",
  "name": "asdf_5"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000036"),
  "price": 7.58104959973,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(3245),
  "active": "No",
  "name": "qwerty_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000037"),
  "price": 98.50585707,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(3579),
  "active": "No",
  "name": "meow_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000038"),
  "price": 32.0483185675,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(8275),
  "active": "Yes",
  "name": "ab'c_quoted_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e2000039"),
  "price": 28.6664097744,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3454),
  "active": "Yes",
  "name": "12\"3_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1927e13064e200003a"),
  "price": 42.6432844122,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6159),
  "active": "Yes",
  "name": "asdf_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200003b"),
  "price": 33.3079689057,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(3380),
  "active": "No",
  "name": "qwerty_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200003c"),
  "price": 56.3150920266,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(9224),
  "active": "No",
  "name": "meow_2"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200003d"),
  "price": 51.4515338325,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(6406),
  "active": "Yes",
  "name": "ab'c_quoted_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200003e"),
  "price": 26.4893219315,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5488),
  "active": "Yes",
  "name": "12\"3_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200003f"),
  "price": 72.9921265455,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4074),
  "active": "Yes",
  "name": "asdf_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000040"),
  "price": 95.3914126826,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(3305),
  "active": "No",
  "name": "qwerty_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000041"),
  "price": 98.9171234271,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(7804),
  "active": "No",
  "name": "meow_5"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000042"),
  "price": 17.6989503536,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(3765),
  "active": "Yes",
  "name": "ab'c_quoted_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000043"),
  "price": 1.2011124312,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6689),
  "active": "Yes",
  "name": "12\"3_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000044"),
  "price": 77.1695312541,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(7402),
  "active": "Yes",
  "name": "asdf_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000045"),
  "price": 21.7186595855,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(3445),
  "active": "No",
  "name": "qwerty_17"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000046"),
  "price": 44.7106996382,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(8608),
  "active": "No",
  "name": "meow_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000047"),
  "price": 5.66934053553,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(897),
  "active": "Yes",
  "name": "ab'c_quoted_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000048"),
  "price": 0.191045636493,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5977),
  "active": "Yes",
  "name": "12\"3_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000049"),
  "price": 17.0254326032,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(958),
  "active": "Yes",
  "name": "asdf_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200004a"),
  "price": 0.872202636074,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4108),
  "active": "No",
  "name": "qwerty_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200004b"),
  "price": 65.530559499,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(7564),
  "active": "No",
  "name": "meow_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200004c"),
  "price": 22.3825221789,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(1247),
  "active": "Yes",
  "name": "ab'c_quoted_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200004d"),
  "price": 66.5500870056,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(2174),
  "active": "Yes",
  "name": "12\"3_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200004e"),
  "price": 83.2145879589,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(7526),
  "active": "Yes",
  "name": "asdf_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e200004f"),
  "price": 66.2403833542,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(1030),
  "active": "No",
  "name": "qwerty_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000050"),
  "price": 5.56717502371,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(3310),
  "active": "No",
  "name": "meow_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000051"),
  "price": 36.3861252508,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(2805),
  "active": "Yes",
  "name": "ab'c_quoted_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000052"),
  "price": 73.5804478853,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(1063),
  "active": "Yes",
  "name": "12\"3_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000053"),
  "price": 83.1264428874,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6178),
  "active": "Yes",
  "name": "asdf_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1a27e13064e2000054"),
  "price": 40.0560605113,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5226),
  "active": "No",
  "name": "qwerty_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000055"),
  "price": 1.19068886475,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(5892),
  "active": "No",
  "name": "meow_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000056"),
  "price": 91.595379867,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5029),
  "active": "Yes",
  "name": "ab'c_quoted_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000057"),
  "price": 31.9879076247,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(8944),
  "active": "Yes",
  "name": "12\"3_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000058"),
  "price": 41.8043343715,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(5600),
  "active": "Yes",
  "name": "asdf_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000059"),
  "price": 89.9871079351,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(7874),
  "active": "No",
  "name": "qwerty_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200005a"),
  "price": 27.8646217281,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(7636),
  "active": "No",
  "name": "meow_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200005b"),
  "price": 44.6065003603,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(1106),
  "active": "Yes",
  "name": "ab'c_quoted_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200005c"),
  "price": 53.0554598256,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(1992),
  "active": "Yes",
  "name": "12\"3_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200005d"),
  "price": 62.8688879193,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9898),
  "active": "Yes",
  "name": "asdf_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200005e"),
  "price": 20.7193632551,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(2378),
  "active": "No",
  "name": "qwerty_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200005f"),
  "price": 27.7653150087,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(743),
  "active": "No",
  "name": "meow_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000060"),
  "price": 44.9955878951,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5033),
  "active": "Yes",
  "name": "ab'c_quoted_2"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000061"),
  "price": 94.2527328436,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(8405),
  "active": "Yes",
  "name": "12\"3_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000062"),
  "price": 92.3653489408,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6887),
  "active": "Yes",
  "name": "asdf_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000063"),
  "price": 47.9934624641,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(7800),
  "active": "No",
  "name": "qwerty_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000064"),
  "price": 39.1172464437,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(5819),
  "active": "No",
  "name": "meow_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000065"),
  "price": 47.4081289239,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(732),
  "active": "Yes",
  "name": "ab'c_quoted_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000066"),
  "price": 62.6767017836,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6812),
  "active": "Yes",
  "name": "12\"3_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000067"),
  "price": 41.430647584,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4070),
  "active": "Yes",
  "name": "asdf_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000068"),
  "price": 95.8086380415,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(2559),
  "active": "No",
  "name": "qwerty_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000069"),
  "price": 2.30818846275,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(8284),
  "active": "No",
  "name": "meow_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200006a"),
  "price": 86.7552069662,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(396),
  "active": "Yes",
  "name": "ab'c_quoted_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200006b"),
  "price": 55.3944418204,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6841),
  "active": "Yes",
  "name": "12\"3_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200006c"),
  "price": 10.7303057403,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9387),
  "active": "Yes",
  "name": "asdf_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200006d"),
  "price": 80.1674522342,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5220),
  "active": "No",
  "name": "qwerty_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200006e"),
  "price": 95.4003379696,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4219),
  "active": "No",
  "name": "meow_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e200006f"),
  "price": 78.1908976288,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(8870),
  "active": "Yes",
  "name": "ab'c_quoted_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000070"),
  "price": 36.5647779181,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6147),
  "active": "Yes",
  "name": "12\"3_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000071"),
  "price": 79.535227112,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(8276),
  "active": "Yes",
  "name": "asdf_2"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000072"),
  "price": 25.4626607354,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(6908),
  "active": "No",
  "name": "qwerty_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1b27e13064e2000073"),
  "price": 51.5168057278,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4623),
  "active": "No",
  "name": "meow_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000074"),
  "price": 40.6256188997,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5209),
  "active": "Yes",
  "name": "ab'c_quoted_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000075"),
  "price": 86.2396346865,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(9222),
  "active": "Yes",
  "name": "12\"3_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000076"),
  "price": 61.3558156811,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(5445),
  "active": "Yes",
  "name": "asdf_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000077"),
  "price": 16.8132035327,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(1375),
  "active": "No",
  "name": "qwerty_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000078"),
  "price": 21.5409227902,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1984),
  "active": "No",
  "name": "meow_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000079"),
  "price": 15.1317884249,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(698),
  "active": "Yes",
  "name": "ab'c_quoted_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200007a"),
  "price": 10.9496029393,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(867),
  "active": "Yes",
  "name": "12\"3_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200007b"),
  "price": 92.2232362941,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6161),
  "active": "Yes",
  "name": "asdf_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200007c"),
  "price": 18.7290431282,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5694),
  "active": "No",
  "name": "qwerty_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200007d"),
  "price": 62.1854146738,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(6406),
  "active": "No",
  "name": "meow_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200007e"),
  "price": 70.7859470088,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(9892),
  "active": "Yes",
  "name": "ab'c_quoted_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200007f"),
  "price": 13.0935541557,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(9701),
  "active": "Yes",
  "name": "12\"3_17"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000080"),
  "price": 65.7963567844,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4791),
  "active": "Yes",
  "name": "asdf_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000081"),
  "price": 95.2831806432,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8767),
  "active": "No",
  "name": "qwerty_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000082"),
  "price": 29.1034284447,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1783),
  "active": "No",
  "name": "meow_5"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000083"),
  "price": 78.5049347188,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5650),
  "active": "Yes",
  "name": "ab'c_quoted_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000084"),
  "price": 43.6839997016,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4724),
  "active": "Yes",
  "name": "12\"3_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000085"),
  "price": 48.7307191721,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(78),
  "active": "Yes",
  "name": "asdf_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000086"),
  "price": 5.54125082513,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(3926),
  "active": "No",
  "name": "qwerty_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000087"),
  "price": 64.3107836581,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(8321),
  "active": "No",
  "name": "meow_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000088"),
  "price": 46.398408056,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7805),
  "active": "Yes",
  "name": "ab'c_quoted_2"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000089"),
  "price": 87.1923003744,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3693),
  "active": "Yes",
  "name": "12\"3_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200008a"),
  "price": 12.4715454629,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(5805),
  "active": "Yes",
  "name": "asdf_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200008b"),
  "price": 76.539742527,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(2916),
  "active": "No",
  "name": "qwerty_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200008c"),
  "price": 48.2016687439,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1812),
  "active": "No",
  "name": "meow_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200008d"),
  "price": 4.48108336257,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(275),
  "active": "Yes",
  "name": "ab'c_quoted_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200008e"),
  "price": 71.4852119801,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(615),
  "active": "Yes",
  "name": "12\"3_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e200008f"),
  "price": 83.021681497,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4806),
  "active": "Yes",
  "name": "asdf_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000090"),
  "price": 2.30896250104,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8701),
  "active": "No",
  "name": "qwerty_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000091"),
  "price": 94.0545667709,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(2092),
  "active": "No",
  "name": "meow_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000092"),
  "price": 25.209619443,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(9062),
  "active": "Yes",
  "name": "ab'c_quoted_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000093"),
  "price": 92.9098452477,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3346),
  "active": "Yes",
  "name": "12\"3_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000094"),
  "price": 63.1096045668,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(5402),
  "active": "Yes",
  "name": "asdf_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1c27e13064e2000095"),
  "price": 44.0176709893,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4030),
  "active": "No",
  "name": "qwerty_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e2000096"),
  "price": 2.24241218829,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4660),
  "active": "No",
  "name": "meow_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e2000097"),
  "price": 54.2698208627,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(6342),
  "active": "Yes",
  "name": "ab'c_quoted_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e2000098"),
  "price": 7.46239091091,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4126),
  "active": "Yes",
  "name": "12\"3_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e2000099"),
  "price": 10.1469191047,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1848),
  "active": "Yes",
  "name": "asdf_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e200009a"),
  "price": 25.320527296,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(6481),
  "active": "No",
  "name": "qwerty_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e200009b"),
  "price": 76.8574523242,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(792),
  "active": "No",
  "name": "meow_17"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e200009c"),
  "price": 21.9602466914,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7434),
  "active": "Yes",
  "name": "ab'c_quoted_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e200009d"),
  "price": 96.4609082272,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(1226),
  "active": "Yes",
  "name": "12\"3_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e200009e"),
  "price": 70.4833474241,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6610),
  "active": "Yes",
  "name": "asdf_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e200009f"),
  "price": 99.1753180472,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5401),
  "active": "No",
  "name": "qwerty_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000a0"),
  "price": 55.9138631723,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(6160),
  "active": "No",
  "name": "meow_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000a1"),
  "price": 83.8331667376,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(805),
  "active": "Yes",
  "name": "ab'c_quoted_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000a2"),
  "price": 39.6997514525,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6452),
  "active": "Yes",
  "name": "12\"3_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000a3"),
  "price": 16.7659221869,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1023),
  "active": "Yes",
  "name": "asdf_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000a4"),
  "price": 95.7367158456,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(9843),
  "active": "No",
  "name": "qwerty_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000a5"),
  "price": 10.4938793718,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(3933),
  "active": "No",
  "name": "meow_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000a6"),
  "price": 95.0815075395,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(811),
  "active": "Yes",
  "name": "ab'c_quoted_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000a7"),
  "price": 16.2992052055,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(9171),
  "active": "Yes",
  "name": "12\"3_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000a8"),
  "price": 37.1673718948,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4687),
  "active": "Yes",
  "name": "asdf_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000a9"),
  "price": 50.670415619,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5271),
  "active": "No",
  "name": "qwerty_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000aa"),
  "price": 15.2927381931,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(3020),
  "active": "No",
  "name": "meow_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000ab"),
  "price": 16.235097092,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(223),
  "active": "Yes",
  "name": "ab'c_quoted_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000ac"),
  "price": 34.9669066501,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(1842),
  "active": "Yes",
  "name": "12\"3_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000ad"),
  "price": 42.1855372749,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9193),
  "active": "Yes",
  "name": "asdf_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000ae"),
  "price": 11.7253313825,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5520),
  "active": "No",
  "name": "qwerty_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000af"),
  "price": 55.0556863397,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(2930),
  "active": "No",
  "name": "meow_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000b0"),
  "price": 92.8047117866,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7775),
  "active": "Yes",
  "name": "ab'c_quoted_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000b1"),
  "price": 64.5618215924,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(698),
  "active": "Yes",
  "name": "12\"3_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000b2"),
  "price": 66.6633428432,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(8769),
  "active": "Yes",
  "name": "asdf_19"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000b3"),
  "price": 41.3039577957,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(6184),
  "active": "No",
  "name": "qwerty_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000b4"),
  "price": 30.7630035198,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(654),
  "active": "No",
  "name": "meow_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000b5"),
  "price": 10.4532831704,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5220),
  "active": "Yes",
  "name": "ab'c_quoted_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000b6"),
  "price": 33.592144104,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5092),
  "active": "Yes",
  "name": "12\"3_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000b7"),
  "price": 83.3902058708,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(5913),
  "active": "Yes",
  "name": "asdf_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000b8"),
  "price": 90.9738914579,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8980),
  "active": "No",
  "name": "qwerty_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000b9"),
  "price": 92.8553847635,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(3993),
  "active": "No",
  "name": "meow_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000ba"),
  "price": 80.0336325304,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(844),
  "active": "Yes",
  "name": "ab'c_quoted_17"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1d27e13064e20000bb"),
  "price": 73.3575003954,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6375),
  "active": "Yes",
  "name": "12\"3_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000bc"),
  "price": 24.7304544461,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(135),
  "active": "Yes",
  "name": "asdf_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000bd"),
  "price": 64.6057123299,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(6179),
  "active": "No",
  "name": "qwerty_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000be"),
  "price": 31.4785841183,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(6676),
  "active": "No",
  "name": "meow_5"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000bf"),
  "price": 52.9554373381,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(1741),
  "active": "Yes",
  "name": "ab'c_quoted_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000c0"),
  "price": 13.6190307502,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(9381),
  "active": "Yes",
  "name": "12\"3_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000c1"),
  "price": 92.293906115,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9335),
  "active": "Yes",
  "name": "asdf_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000c2"),
  "price": 26.6628641561,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(9048),
  "active": "No",
  "name": "qwerty_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000c3"),
  "price": 71.1580562845,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1615),
  "active": "No",
  "name": "meow_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000c4"),
  "price": 11.6083810928,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(2621),
  "active": "Yes",
  "name": "ab'c_quoted_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000c5"),
  "price": 72.5931642908,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3657),
  "active": "Yes",
  "name": "12\"3_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000c6"),
  "price": 71.4024440458,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6018),
  "active": "Yes",
  "name": "asdf_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000c7"),
  "price": 26.6926548044,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(7762),
  "active": "No",
  "name": "qwerty_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000c8"),
  "price": 76.3200269792,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(9494),
  "active": "No",
  "name": "meow_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000c9"),
  "price": 62.6030316281,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5411),
  "active": "Yes",
  "name": "ab'c_quoted_5"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000ca"),
  "price": 3.58024040752,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(7782),
  "active": "Yes",
  "name": "12\"3_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000cb"),
  "price": 64.6588324698,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(2833),
  "active": "Yes",
  "name": "asdf_17"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000cc"),
  "price": 29.6683876753,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8888),
  "active": "No",
  "name": "qwerty_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000cd"),
  "price": 52.342873402,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(5314),
  "active": "No",
  "name": "meow_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000ce"),
  "price": 88.5570313601,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(9313),
  "active": "Yes",
  "name": "ab'c_quoted_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000cf"),
  "price": 52.4563420164,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(8547),
  "active": "Yes",
  "name": "12\"3_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000d0"),
  "price": 99.0955854644,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4864),
  "active": "Yes",
  "name": "asdf_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000d1"),
  "price": 18.8782116745,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5809),
  "active": "No",
  "name": "qwerty_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000d2"),
  "price": 86.0589270447,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(3599),
  "active": "No",
  "name": "meow_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000d3"),
  "price": 98.1205467594,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5179),
  "active": "Yes",
  "name": "ab'c_quoted_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000d4"),
  "price": 93.420914909,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5122),
  "active": "Yes",
  "name": "12\"3_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000d5"),
  "price": 50.1851200535,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9231),
  "active": "Yes",
  "name": "asdf_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000d6"),
  "price": 63.7187084715,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(7226),
  "active": "No",
  "name": "qwerty_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000d7"),
  "price": 35.2646084011,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(6945),
  "active": "No",
  "name": "meow_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000d8"),
  "price": 53.058665212,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(466),
  "active": "Yes",
  "name": "ab'c_quoted_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000d9"),
  "price": 12.6563911002,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5336),
  "active": "Yes",
  "name": "12\"3_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000da"),
  "price": 36.4182917417,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(5957),
  "active": "Yes",
  "name": "asdf_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000db"),
  "price": 59.1158241567,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(178),
  "active": "No",
  "name": "qwerty_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000dc"),
  "price": 4.26773545084,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(2640),
  "active": "No",
  "name": "meow_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000dd"),
  "price": 86.697760698,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(8653),
  "active": "Yes",
  "name": "ab'c_quoted_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000de"),
  "price": 51.2497993118,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3032),
  "active": "Yes",
  "name": "12\"3_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000df"),
  "price": 93.0174934054,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9669),
  "active": "Yes",
  "name": "asdf_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000e0"),
  "price": 37.6707205126,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(103),
  "active": "No",
  "name": "qwerty_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000e1"),
  "price": 72.736750377,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4725),
  "active": "No",
  "name": "meow_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000e2"),
  "price": 78.6801892451,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(1579),
  "active": "Yes",
  "name": "ab'c_quoted_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000e3"),
  "price": 21.3506521259,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6354),
  "active": "Yes",
  "name": "12\"3_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000e4"),
  "price": 78.9450109093,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6447),
  "active": "Yes",
  "name": "asdf_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000e5"),
  "price": 76.0072921292,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8861),
  "active": "No",
  "name": "qwerty_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000e6"),
  "price": 47.0384548591,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4047),
  "active": "No",
  "name": "meow_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000e7"),
  "price": 52.8189987604,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(9181),
  "active": "Yes",
  "name": "ab'c_quoted_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000e8"),
  "price": 32.9128689084,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(2012),
  "active": "Yes",
  "name": "12\"3_31"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000e9"),
  "price": 96.1106079229,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9938),
  "active": "Yes",
  "name": "asdf_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000ea"),
  "price": 92.2503884055,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4226),
  "active": "No",
  "name": "qwerty_17"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000eb"),
  "price": 17.4035609104,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(5385),
  "active": "No",
  "name": "meow_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000ec"),
  "price": 81.760562296,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(3597),
  "active": "Yes",
  "name": "ab'c_quoted_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000ed"),
  "price": 94.1790859917,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4558),
  "active": "Yes",
  "name": "12\"3_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000ee"),
  "price": 30.5425896215,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4807),
  "active": "Yes",
  "name": "asdf_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000ef"),
  "price": 54.7826333317,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4591),
  "active": "No",
  "name": "qwerty_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000f0"),
  "price": 89.3649828597,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4868),
  "active": "No",
  "name": "meow_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1e27e13064e20000f1"),
  "price": 87.6320110803,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(4901),
  "active": "Yes",
  "name": "ab'c_quoted_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000f2"),
  "price": 77.8543094554,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(7274),
  "active": "Yes",
  "name": "12\"3_19"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000f3"),
  "price": 81.1264474593,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(7442),
  "active": "Yes",
  "name": "asdf_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000f4"),
  "price": 54.8068771765,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(9874),
  "active": "No",
  "name": "qwerty_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000f5"),
  "price": 95.2392943901,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(5530),
  "active": "No",
  "name": "meow_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000f6"),
  "price": 10.6057716508,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(2078),
  "active": "Yes",
  "name": "ab'c_quoted_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000f7"),
  "price": 93.5251835311,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5807),
  "active": "Yes",
  "name": "12\"3_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000f8"),
  "price": 84.2971130382,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(2927),
  "active": "Yes",
  "name": "asdf_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000f9"),
  "price": 3.67699346165,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(2752),
  "active": "No",
  "name": "qwerty_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000fa"),
  "price": 38.2077162254,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1129),
  "active": "No",
  "name": "meow_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000fb"),
  "price": 41.0152291758,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(16),
  "active": "Yes",
  "name": "ab'c_quoted_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000fc"),
  "price": 53.0281743746,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5087),
  "active": "Yes",
  "name": "12\"3_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000fd"),
  "price": 89.3691594519,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1813),
  "active": "Yes",
  "name": "asdf_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000fe"),
  "price": 17.6908653797,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(103),
  "active": "No",
  "name": "qwerty_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e20000ff"),
  "price": 86.7305772531,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(9829),
  "active": "No",
  "name": "meow_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000100"),
  "price": 73.4955926706,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(6328),
  "active": "Yes",
  "name": "ab'c_quoted_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000101"),
  "price": 69.8180458355,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(8085),
  "active": "Yes",
  "name": "12\"3_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000102"),
  "price": 52.7355306602,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(7404),
  "active": "Yes",
  "name": "asdf_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000103"),
  "price": 35.1630629126,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8937),
  "active": "No",
  "name": "qwerty_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000104"),
  "price": 9.13955738324,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4107),
  "active": "No",
  "name": "meow_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000105"),
  "price": 0.889308161092,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(9554),
  "active": "Yes",
  "name": "ab'c_quoted_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000106"),
  "price": 89.6373506005,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3559),
  "active": "Yes",
  "name": "12\"3_5"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000107"),
  "price": 10.6216093822,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(8479),
  "active": "Yes",
  "name": "asdf_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000108"),
  "price": 40.6833736885,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(451),
  "active": "No",
  "name": "qwerty_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000109"),
  "price": 82.5426753977,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(8270),
  "active": "No",
  "name": "meow_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e200010a"),
  "price": 62.7076414267,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(3737),
  "active": "Yes",
  "name": "ab'c_quoted_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e200010b"),
  "price": 31.498785166,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6680),
  "active": "Yes",
  "name": "12\"3_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e200010c"),
  "price": 56.4705210753,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6523),
  "active": "Yes",
  "name": "asdf_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e200010d"),
  "price": 15.4864982856,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(659),
  "active": "No",
  "name": "qwerty_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e200010e"),
  "price": 65.2420031342,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(8469),
  "active": "No",
  "name": "meow_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e200010f"),
  "price": 37.9079650195,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(2654),
  "active": "Yes",
  "name": "ab'c_quoted_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000110"),
  "price": 7.04203439118,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(81),
  "active": "Yes",
  "name": "12\"3_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000111"),
  "price": 56.5428986929,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(391),
  "active": "Yes",
  "name": "asdf_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000112"),
  "price": 11.8899294644,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4216),
  "active": "No",
  "name": "qwerty_31"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000113"),
  "price": 21.3509217007,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4487),
  "active": "No",
  "name": "meow_31"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef1f27e13064e2000114"),
  "price": 20.3805532401,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(8637),
  "active": "Yes",
  "name": "ab'c_quoted_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000115"),
  "price": 77.873912917,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(9863),
  "active": "Yes",
  "name": "12\"3_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000116"),
  "price": 56.0876398121,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(7811),
  "active": "Yes",
  "name": "asdf_19"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000117"),
  "price": 23.9186586142,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(7503),
  "active": "No",
  "name": "qwerty_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000118"),
  "price": 24.3278802382,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(3304),
  "active": "No",
  "name": "meow_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000119"),
  "price": 52.1755176963,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(3030),
  "active": "Yes",
  "name": "ab'c_quoted_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200011a"),
  "price": 56.9947612818,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5802),
  "active": "Yes",
  "name": "12\"3_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200011b"),
  "price": 13.3422294773,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(8607),
  "active": "Yes",
  "name": "asdf_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200011c"),
  "price": 4.06346660606,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4576),
  "active": "No",
  "name": "qwerty_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200011d"),
  "price": 27.6763062968,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(620),
  "active": "No",
  "name": "meow_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200011e"),
  "price": 5.81782399747,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5804),
  "active": "Yes",
  "name": "ab'c_quoted_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200011f"),
  "price": 0.808805535408,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4542),
  "active": "Yes",
  "name": "12\"3_2"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000120"),
  "price": 6.33201116796,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(2447),
  "active": "Yes",
  "name": "asdf_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000121"),
  "price": 67.942195931,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(1547),
  "active": "No",
  "name": "qwerty_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000122"),
  "price": 47.0119944117,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(5434),
  "active": "No",
  "name": "meow_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000123"),
  "price": 84.4982130912,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7094),
  "active": "Yes",
  "name": "ab'c_quoted_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000124"),
  "price": 88.5910107281,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6549),
  "active": "Yes",
  "name": "12\"3_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000125"),
  "price": 49.2805281705,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9981),
  "active": "Yes",
  "name": "asdf_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000126"),
  "price": 22.2604319854,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(6202),
  "active": "No",
  "name": "qwerty_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000127"),
  "price": 52.7516968096,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1029),
  "active": "No",
  "name": "meow_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000128"),
  "price": 2.21637310572,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5013),
  "active": "Yes",
  "name": "ab'c_quoted_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000129"),
  "price": 36.309047255,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4458),
  "active": "Yes",
  "name": "12\"3_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200012a"),
  "price": 52.6857274377,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6267),
  "active": "Yes",
  "name": "asdf_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200012b"),
  "price": 35.0790152685,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4506),
  "active": "No",
  "name": "qwerty_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200012c"),
  "price": 0.199129515916,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(5761),
  "active": "No",
  "name": "meow_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200012d"),
  "price": 60.6665687662,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5088),
  "active": "Yes",
  "name": "ab'c_quoted_31"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200012e"),
  "price": 88.1515616175,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4465),
  "active": "Yes",
  "name": "12\"3_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200012f"),
  "price": 2.21021252226,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(2912),
  "active": "Yes",
  "name": "asdf_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000130"),
  "price": 89.9613502615,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(2730),
  "active": "No",
  "name": "qwerty_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000131"),
  "price": 94.4252916012,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4833),
  "active": "No",
  "name": "meow_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000132"),
  "price": 59.6169545172,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(2654),
  "active": "Yes",
  "name": "ab'c_quoted_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000133"),
  "price": 81.5631572726,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(2367),
  "active": "Yes",
  "name": "12\"3_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000134"),
  "price": 39.9621842642,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9277),
  "active": "Yes",
  "name": "asdf_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000135"),
  "price": 97.5557284635,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(3291),
  "active": "No",
  "name": "qwerty_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000136"),
  "price": 15.3920295116,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1841),
  "active": "No",
  "name": "meow_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000137"),
  "price": 35.5422848473,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(3632),
  "active": "Yes",
  "name": "ab'c_quoted_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000138"),
  "price": 7.16244966832,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(8511),
  "active": "Yes",
  "name": "12\"3_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000139"),
  "price": 57.3832969391,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(303),
  "active": "Yes",
  "name": "asdf_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200013a"),
  "price": 90.1965281739,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(2511),
  "active": "No",
  "name": "qwerty_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200013b"),
  "price": 6.08946258758,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1324),
  "active": "No",
  "name": "meow_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200013c"),
  "price": 13.8257243447,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(2727),
  "active": "Yes",
  "name": "ab'c_quoted_17"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200013d"),
  "price": 74.9718574105,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6786),
  "active": "Yes",
  "name": "12\"3_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200013e"),
  "price": 28.1969775479,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6468),
  "active": "Yes",
  "name": "asdf_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e200013f"),
  "price": 44.1373632507,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(1025),
  "active": "No",
  "name": "qwerty_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000140"),
  "price": 18.5762144236,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1076),
  "active": "No",
  "name": "meow_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000141"),
  "price": 19.1027530201,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(3841),
  "active": "Yes",
  "name": "ab'c_quoted_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000142"),
  "price": 71.4523224301,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6135),
  "active": "Yes",
  "name": "12\"3_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2027e13064e2000143"),
  "price": 72.7446852066,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1132),
  "active": "Yes",
  "name": "asdf_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000144"),
  "price": 21.0491883632,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(1962),
  "active": "No",
  "name": "qwerty_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000145"),
  "price": 53.5454085963,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(2412),
  "active": "No",
  "name": "meow_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000146"),
  "price": 20.1758993781,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(2623),
  "active": "Yes",
  "name": "ab'c_quoted_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000147"),
  "price": 48.6678926361,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(2158),
  "active": "Yes",
  "name": "12\"3_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000148"),
  "price": 39.6854509714,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(3376),
  "active": "Yes",
  "name": "asdf_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000149"),
  "price": 4.96420638986,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(1529),
  "active": "No",
  "name": "qwerty_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200014a"),
  "price": 17.2080935076,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(936),
  "active": "No",
  "name": "meow_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200014b"),
  "price": 13.8170515228,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(4155),
  "active": "Yes",
  "name": "ab'c_quoted_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200014c"),
  "price": 44.7607023534,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6773),
  "active": "Yes",
  "name": "12\"3_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200014d"),
  "price": 26.9178170907,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(3917),
  "active": "Yes",
  "name": "asdf_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200014e"),
  "price": 19.0635792785,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5252),
  "active": "No",
  "name": "qwerty_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200014f"),
  "price": 66.6083189536,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(6186),
  "active": "No",
  "name": "meow_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000150"),
  "price": 42.8682916283,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(2600),
  "active": "Yes",
  "name": "ab'c_quoted_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000151"),
  "price": 86.389197893,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(2316),
  "active": "Yes",
  "name": "12\"3_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000152"),
  "price": 8.46902969047,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(5125),
  "active": "Yes",
  "name": "asdf_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000153"),
  "price": 29.1190854699,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8982),
  "active": "No",
  "name": "qwerty_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000154"),
  "price": 37.8578289008,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(7296),
  "active": "No",
  "name": "meow_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000155"),
  "price": 19.7636407297,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5694),
  "active": "Yes",
  "name": "ab'c_quoted_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000156"),
  "price": 39.417244444,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3060),
  "active": "Yes",
  "name": "12\"3_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000157"),
  "price": 57.6937266853,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4316),
  "active": "Yes",
  "name": "asdf_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000158"),
  "price": 22.4331185185,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(9502),
  "active": "No",
  "name": "qwerty_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000159"),
  "price": 20.9692918615,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(343),
  "active": "No",
  "name": "meow_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200015a"),
  "price": 68.234687623,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7337),
  "active": "Yes",
  "name": "ab'c_quoted_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200015b"),
  "price": 46.097359233,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3409),
  "active": "Yes",
  "name": "12\"3_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200015c"),
  "price": 35.8868688253,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6597),
  "active": "Yes",
  "name": "asdf_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200015d"),
  "price": 4.78553597395,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8244),
  "active": "No",
  "name": "qwerty_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200015e"),
  "price": 7.65925600264,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(7748),
  "active": "No",
  "name": "meow_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e200015f"),
  "price": 59.5157167251,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(2396),
  "active": "Yes",
  "name": "ab'c_quoted_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000160"),
  "price": 80.569497835,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6365),
  "active": "Yes",
  "name": "12\"3_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000161"),
  "price": 58.7802696797,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6515),
  "active": "Yes",
  "name": "asdf_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000162"),
  "price": 45.368897976,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(1589),
  "active": "No",
  "name": "qwerty_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000163"),
  "price": 24.6062782008,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1972),
  "active": "No",
  "name": "meow_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000164"),
  "price": 35.1753091324,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(1152),
  "active": "Yes",
  "name": "ab'c_quoted_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000165"),
  "price": 29.7175230746,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3099),
  "active": "Yes",
  "name": "12\"3_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000166"),
  "price": 59.9054096637,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6431),
  "active": "Yes",
  "name": "asdf_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2127e13064e2000167"),
  "price": 52.8221361408,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(6774),
  "active": "No",
  "name": "qwerty_2"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000168"),
  "price": 57.9745824826,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(9321),
  "active": "No",
  "name": "meow_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000169"),
  "price": 33.3680960986,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5914),
  "active": "Yes",
  "name": "ab'c_quoted_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200016a"),
  "price": 5.08392622531,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6297),
  "active": "Yes",
  "name": "12\"3_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200016b"),
  "price": 35.321847323,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(3747),
  "active": "Yes",
  "name": "asdf_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200016c"),
  "price": 20.0620176577,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8460),
  "active": "No",
  "name": "qwerty_19"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200016d"),
  "price": 63.7548186029,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(2741),
  "active": "No",
  "name": "meow_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200016e"),
  "price": 20.201497947,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(9103),
  "active": "Yes",
  "name": "ab'c_quoted_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200016f"),
  "price": 14.1344456731,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(8975),
  "active": "Yes",
  "name": "12\"3_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000170"),
  "price": 12.29105934,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(3851),
  "active": "Yes",
  "name": "asdf_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000171"),
  "price": 77.9771725677,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4375),
  "active": "No",
  "name": "qwerty_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000172"),
  "price": 28.4644820115,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(7617),
  "active": "No",
  "name": "meow_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000173"),
  "price": 28.957303778,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5092),
  "active": "Yes",
  "name": "ab'c_quoted_5"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000174"),
  "price": 86.5666293369,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3951),
  "active": "Yes",
  "name": "12\"3_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000175"),
  "price": 84.6748551045,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(8952),
  "active": "Yes",
  "name": "asdf_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000176"),
  "price": 68.5581941035,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(472),
  "active": "No",
  "name": "qwerty_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000177"),
  "price": 17.7274724687,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(9006),
  "active": "No",
  "name": "meow_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000178"),
  "price": 49.5018203274,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(4887),
  "active": "Yes",
  "name": "ab'c_quoted_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e2000179"),
  "price": 39.3700715423,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6900),
  "active": "Yes",
  "name": "12\"3_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200017a"),
  "price": 80.9691854105,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(122),
  "active": "Yes",
  "name": "asdf_3"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200017b"),
  "price": 2.76970357857,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(7062),
  "active": "No",
  "name": "qwerty_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200017c"),
  "price": 97.4062770698,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(8876),
  "active": "No",
  "name": "meow_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200017d"),
  "price": 34.8652488073,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5417),
  "active": "Yes",
  "name": "ab'c_quoted_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200017e"),
  "price": 60.827060375,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3901),
  "active": "Yes",
  "name": "12\"3_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2227e13064e200017f"),
  "price": 72.5046396096,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(7959),
  "active": "Yes",
  "name": "asdf_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2327e13064e2000180"),
  "price": 17.6872926672,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(7373),
  "active": "No",
  "name": "qwerty_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2327e13064e2000181"),
  "price": 63.0558749285,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(8257),
  "active": "No",
  "name": "meow_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2327e13064e2000182"),
  "price": 99.9149035391,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(1702),
  "active": "Yes",
  "name": "ab'c_quoted_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2327e13064e2000183"),
  "price": 14.7237608705,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(7028),
  "active": "Yes",
  "name": "12\"3_31"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2327e13064e2000184"),
  "price": 0.327696061617,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6638),
  "active": "Yes",
  "name": "asdf_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2327e13064e2000185"),
  "price": 17.7700341047,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(667),
  "active": "No",
  "name": "qwerty_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2327e13064e2000186"),
  "price": 11.7730984272,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4286),
  "active": "No",
  "name": "meow_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e2000187"),
  "price": 94.5525231179,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(8887),
  "active": "Yes",
  "name": "ab'c_quoted_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e2000188"),
  "price": 4.47129248423,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(7587),
  "active": "Yes",
  "name": "12\"3_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e2000189"),
  "price": 30.3774804808,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(7137),
  "active": "Yes",
  "name": "asdf_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e200018a"),
  "price": 0.444212714795,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4800),
  "active": "No",
  "name": "qwerty_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e200018b"),
  "price": 72.4269671464,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(2457),
  "active": "No",
  "name": "meow_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e200018c"),
  "price": 34.2795505371,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5369),
  "active": "Yes",
  "name": "ab'c_quoted_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e200018d"),
  "price": 95.1881758433,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6011),
  "active": "Yes",
  "name": "12\"3_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e200018e"),
  "price": 56.1074148708,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1057),
  "active": "Yes",
  "name": "asdf_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e200018f"),
  "price": 79.3318149401,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(3029),
  "active": "No",
  "name": "qwerty_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e2000190"),
  "price": 57.596805373,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(468),
  "active": "No",
  "name": "meow_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2527e13064e2000191"),
  "price": 96.7487129189,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(6770),
  "active": "Yes",
  "name": "ab'c_quoted_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e2000192"),
  "price": 56.6107634119,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4495),
  "active": "Yes",
  "name": "12\"3_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e2000193"),
  "price": 46.7577390012,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(3489),
  "active": "Yes",
  "name": "asdf_13"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e2000194"),
  "price": 76.117853748,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5621),
  "active": "No",
  "name": "qwerty_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e2000195"),
  "price": 30.8305153773,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1227),
  "active": "No",
  "name": "meow_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e2000196"),
  "price": 48.096084679,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(4564),
  "active": "Yes",
  "name": "ab'c_quoted_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e2000197"),
  "price": 74.7894721141,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3018),
  "active": "Yes",
  "name": "12\"3_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e2000198"),
  "price": 71.074498956,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9889),
  "active": "Yes",
  "name": "asdf_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e2000199"),
  "price": 27.7188059744,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(2596),
  "active": "No",
  "name": "qwerty_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e200019a"),
  "price": 43.1821144828,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1819),
  "active": "No",
  "name": "meow_26"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e200019b"),
  "price": 38.5393377555,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7808),
  "active": "Yes",
  "name": "ab'c_quoted_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e200019c"),
  "price": 64.9991894489,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(3391),
  "active": "Yes",
  "name": "12\"3_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e200019d"),
  "price": 36.2082357878,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(8484),
  "active": "Yes",
  "name": "asdf_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e200019e"),
  "price": 41.5167617144,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5735),
  "active": "No",
  "name": "qwerty_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e200019f"),
  "price": 84.8104323554,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(6110),
  "active": "No",
  "name": "meow_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e20001a0"),
  "price": 34.9952758166,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(6959),
  "active": "Yes",
  "name": "ab'c_quoted_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e20001a1"),
  "price": 10.6370897664,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4203),
  "active": "Yes",
  "name": "12\"3_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e20001a2"),
  "price": 25.7440598453,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(5742),
  "active": "Yes",
  "name": "asdf_19"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e20001a3"),
  "price": 12.7748783866,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(132),
  "active": "No",
  "name": "qwerty_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e20001a4"),
  "price": 78.1511085788,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1),
  "active": "No",
  "name": "meow_6"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e20001a5"),
  "price": 13.9127652376,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(432),
  "active": "Yes",
  "name": "ab'c_quoted_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e20001a6"),
  "price": 47.1744472359,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5198),
  "active": "Yes",
  "name": "12\"3_19"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e20001a7"),
  "price": 3.11222977471,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6216),
  "active": "Yes",
  "name": "asdf_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2627e13064e20001a8"),
  "price": 76.6940649432,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(2335),
  "active": "No",
  "name": "qwerty_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001a9"),
  "price": 33.7514983085,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(9368),
  "active": "No",
  "name": "meow_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001aa"),
  "price": 6.54306189518,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(489),
  "active": "Yes",
  "name": "ab'c_quoted_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001ab"),
  "price": 62.5652671602,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6187),
  "active": "Yes",
  "name": "12\"3_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001ac"),
  "price": 62.3921972187,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(3126),
  "active": "Yes",
  "name": "asdf_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001ad"),
  "price": 21.8881936129,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(638),
  "active": "No",
  "name": "qwerty_5"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001ae"),
  "price": 55.9194153337,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(6848),
  "active": "No",
  "name": "meow_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001af"),
  "price": 47.8270849368,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(1819),
  "active": "Yes",
  "name": "ab'c_quoted_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001b0"),
  "price": 71.1146752681,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6962),
  "active": "Yes",
  "name": "12\"3_17"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001b1"),
  "price": 19.6618342696,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9281),
  "active": "Yes",
  "name": "asdf_8"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001b2"),
  "price": 77.9957687934,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8323),
  "active": "No",
  "name": "qwerty_19"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001b3"),
  "price": 73.6465731187,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(6837),
  "active": "No",
  "name": "meow_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001b4"),
  "price": 84.9480982182,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(1024),
  "active": "Yes",
  "name": "ab'c_quoted_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001b5"),
  "price": 9.05884330746,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(8586),
  "active": "Yes",
  "name": "12\"3_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001b6"),
  "price": 12.5015996592,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(9124),
  "active": "Yes",
  "name": "asdf_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001b7"),
  "price": 13.9426001154,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(4490),
  "active": "No",
  "name": "qwerty_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001b8"),
  "price": 1.21789038188,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1262),
  "active": "No",
  "name": "meow_23"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001b9"),
  "price": 63.5106239534,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(574),
  "active": "Yes",
  "name": "ab'c_quoted_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001ba"),
  "price": 41.4886996724,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(5156),
  "active": "Yes",
  "name": "12\"3_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001bb"),
  "price": 82.1891088474,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6758),
  "active": "Yes",
  "name": "asdf_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001bc"),
  "price": 84.846980563,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8202),
  "active": "No",
  "name": "qwerty_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001bd"),
  "price": 0.275596705167,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4656),
  "active": "No",
  "name": "meow_32"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001be"),
  "price": 8.30566028149,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(2149),
  "active": "Yes",
  "name": "ab'c_quoted_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001bf"),
  "price": 62.9206295418,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(8860),
  "active": "Yes",
  "name": "12\"3_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001c0"),
  "price": 2.17660838966,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(842),
  "active": "Yes",
  "name": "asdf_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001c1"),
  "price": 45.7794164554,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5626),
  "active": "No",
  "name": "qwerty_25"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001c2"),
  "price": 78.2206003749,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4972),
  "active": "No",
  "name": "meow_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001c3"),
  "price": 97.2591367148,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(99),
  "active": "Yes",
  "name": "ab'c_quoted_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001c4"),
  "price": 73.4557220377,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(2847),
  "active": "Yes",
  "name": "12\"3_20"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001c5"),
  "price": 78.344207029,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(5952),
  "active": "Yes",
  "name": "asdf_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001c6"),
  "price": 41.3883532081,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(6005),
  "active": "No",
  "name": "qwerty_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001c7"),
  "price": 45.7787549525,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(4138),
  "active": "No",
  "name": "meow_30"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001c8"),
  "price": 38.0772492927,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(734),
  "active": "Yes",
  "name": "ab'c_quoted_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2727e13064e20001c9"),
  "price": 85.6985196107,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(6636),
  "active": "Yes",
  "name": "12\"3_17"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001ca"),
  "price": 36.5491572682,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1523),
  "active": "Yes",
  "name": "asdf_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001cb"),
  "price": 78.683301451,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(1247),
  "active": "No",
  "name": "qwerty_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001cc"),
  "price": 63.7767482974,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(7119),
  "active": "No",
  "name": "meow_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001cd"),
  "price": 44.056357848,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(9498),
  "active": "Yes",
  "name": "ab'c_quoted_14"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001ce"),
  "price": 62.8502646171,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(1856),
  "active": "Yes",
  "name": "12\"3_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001cf"),
  "price": 63.609342665,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(2302),
  "active": "Yes",
  "name": "asdf_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001d0"),
  "price": 16.6546119162,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(2006),
  "active": "No",
  "name": "qwerty_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001d1"),
  "price": 94.8809063984,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1494),
  "active": "No",
  "name": "meow_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001d2"),
  "price": 65.9378465199,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(1025),
  "active": "Yes",
  "name": "ab'c_quoted_28"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001d3"),
  "price": 15.3309981864,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(377),
  "active": "Yes",
  "name": "12\"3_0"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001d4"),
  "price": 74.6161273465,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1679),
  "active": "Yes",
  "name": "asdf_34"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001d5"),
  "price": 5.9042438671,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8755),
  "active": "No",
  "name": "qwerty_19"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001d6"),
  "price": 53.8879900098,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(2775),
  "active": "No",
  "name": "meow_4"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001d7"),
  "price": 42.3610642595,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(1097),
  "active": "Yes",
  "name": "ab'c_quoted_1"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001d8"),
  "price": 75.4804358497,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(7693),
  "active": "Yes",
  "name": "12\"3_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001d9"),
  "price": 17.9955137452,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(4487),
  "active": "Yes",
  "name": "asdf_10"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001da"),
  "price": 10.1376038399,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(8984),
  "active": "No",
  "name": "qwerty_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001db"),
  "price": 32.0004731764,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(9974),
  "active": "No",
  "name": "meow_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001dc"),
  "price": 67.593976168,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5223),
  "active": "Yes",
  "name": "ab'c_quoted_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001dd"),
  "price": 49.501974562,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(9803),
  "active": "Yes",
  "name": "12\"3_18"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001de"),
  "price": 97.6683773251,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(1697),
  "active": "Yes",
  "name": "asdf_2"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001df"),
  "price": 98.9185244139,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5391),
  "active": "No",
  "name": "qwerty_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001e0"),
  "price": 71.5993745411,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(5975),
  "active": "No",
  "name": "meow_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001e1"),
  "price": 56.897727822,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(6590),
  "active": "Yes",
  "name": "ab'c_quoted_22"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001e2"),
  "price": 92.4485440058,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(7147),
  "active": "Yes",
  "name": "12\"3_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001e3"),
  "price": 26.7782749674,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(3101),
  "active": "Yes",
  "name": "asdf_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001e4"),
  "price": 80.5836884115,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(3097),
  "active": "No",
  "name": "qwerty_12"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001e5"),
  "price": 94.1091238958,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(2016),
  "active": "No",
  "name": "meow_16"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001e6"),
  "price": 40.9743208718,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(7548),
  "active": "Yes",
  "name": "ab'c_quoted_19"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001e7"),
  "price": 78.5967071769,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(4431),
  "active": "Yes",
  "name": "12\"3_11"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001e8"),
  "price": 29.3343044837,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(185),
  "active": "Yes",
  "name": "asdf_24"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001e9"),
  "price": 28.4679955181,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(5066),
  "active": "No",
  "name": "qwerty_33"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2827e13064e20001ea"),
  "price": 93.1423872813,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(7799),
  "active": "No",
  "name": "meow_7"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2927e13064e20001eb"),
  "price": 27.1999445488,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(5640),
  "active": "Yes",
  "name": "ab'c_quoted_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2927e13064e20001ec"),
  "price": 23.9069028382,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(7255),
  "active": "Yes",
  "name": "12\"3_27"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2927e13064e20001ed"),
  "price": 24.6562793983,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(6861),
  "active": "Yes",
  "name": "asdf_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2927e13064e20001ee"),
  "price": 65.383945755,
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "sku": NumberInt(348),
  "active": "No",
  "name": "qwerty_21"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2927e13064e20001ef"),
  "price": 39.464040152,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(9960),
  "active": "No",
  "name": "meow_29"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2927e13064e20001f0"),
  "price": 59.8867253182,
  "date_added": ISODate("2008-02-01T00:00:00.0Z"),
  "sku": NumberInt(8688),
  "active": "Yes",
  "name": "ab'c_quoted_9"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2927e13064e20001f1"),
  "price": 41.0951610374,
  "date_added": ISODate("2008-02-02T00:00:00.0Z"),
  "sku": NumberInt(7860),
  "active": "Yes",
  "name": "12\"3_19"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2927e13064e20001f2"),
  "price": 59.0433035912,
  "date_added": ISODate("2008-02-03T00:00:00.0Z"),
  "sku": NumberInt(3783),
  "active": "Yes",
  "name": "asdf_15"
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2927e13064e20001f3"),
  "active": "No",
  "date_added": ISODate("2008-02-04T00:00:00.0Z"),
  "name": "6701",
  "price": 82.3650582374,
  "sku": NumberLong(1522)
});
db.getCollection("items").insert({
  "_id": ObjectId("51adef2927e13064e20001f4"),
  "price": 15.9390474817,
  "date_added": ISODate("2008-02-05T00:00:00.0Z"),
  "sku": NumberInt(1522),
  "active": "No",
  "name": "meow_11"
});

=end

    begin

      list_parms   = WidgetList::List::init_config()

      #
      # Give it a name, some SQL to feed widget_list and set a noDataMessage
      #
      list_parms['database']      = 'secondary'
      list_parms['name']          = 'ruby_items_yum'

      #
      # Handle Dynamic Filters


      #list_parms = WidgetList::List.where(list_parms,'name','meow_22')
      #list_parms = WidgetList::List.where(list_parms,'sku','4833','>=')
      list_parms = WidgetList::List.where(list_parms,'date_added','2008-02-05,2008-02-01','in')
      #list_parms = WidgetList::List.where(list_parms,'name','qwerty_9,qwerty_8','in')

      drillDown, filterValue  = WidgetList::List::get_filter_and_drilldown(list_parms['name'])

      #
      # Since Sequel is not being used you must escape bindVars yourself!!
      #

      case drillDown
        when 'filter_by_name'
          list_parms['filter']   << "name"
          #
          # Since Sequel is not being used you must escape bindVars yourself!!
          #
          list_parms['bindVars'] << Item.sanitize(filterValue)
          list_parms['listDescription']   = WidgetList::List::drill_down_back(list_parms['name']) + ' Filtered by Name (' + filterValue + ')'
        when 'filter_by_sku'
          list_parms['filter']   << "sku"
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
      list_parms['searchIdCol']   = ['sku']

      #
      # Because sku_linked column is being used and the raw SKU is hidden, we need to make this available for searching via fields_hidden
      #
      list_parms['fieldsHidden'] = {}
      list_parms['fieldsHidden']['sku']         = 'sku'
      list_parms['fieldsHidden']['_id']         = '_id'
      list_parms['fieldsHidden']['date_added']  = 'date_added'
      list_parms['fieldsHidden']['name']        = 'name'

      list_parms['view']           = Item

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
        list_parms['totalRow']['sku']                  = 'sku'
        list_parms['totalRowMethod']['price']          = 'average'
        list_parms['totalRowPrefix']['price']          = 'Average Price<br/>'
      end


      list_parms['groupByItems'] = ['All Items', 'Name', 'Sku','Averages And Sum']

      #
      # Fields
      #

      list_parms['fields']['name']                      =  'Name'                  if groupByFilter == 'none' || groupByFilter == 'group_name'
      list_parms['fields']['price']                            =  'Price'                 if groupByFilter == 'none'
      list_parms['fields']['sku']                       =  'Sku'                   if groupByFilter == 'none' || groupByFilter == 'group_sku'
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
      mini_buttons['button_edit'] = {'page'       => '/edit/_id/',
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
      list_parms['fieldFunction']['checkbox']                  = '\'\''

      #
      # Setup a custom field for checkboxes stored into the session and reloaded when refresh occurs
      #
      list_parms = WidgetList::List.checkbox_helper(list_parms,'_id')

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
        'sku'=>'20px',
      }

      list_parms['columnPopupTitle'] = {}
      list_parms['columnPopupTitle']['checkbox']         = 'Select any record'
      list_parms['columnPopupTitle']['name']             = 'Name (Click to drill down)'
      list_parms['columnPopupTitle']['price']            = 'Price of item (not formatted)'
      list_parms['columnPopupTitle']['sku']              = 'Sku # (Click to drill down)'
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