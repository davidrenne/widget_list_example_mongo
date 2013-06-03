module WidgetListHelper
  class SiteDefaults

    #
    # below function will allow you to over-ride all lists within your application
    #

    def self.get_site_widget_list_defaults()

      list_parms = {}
      list_parms['searchTitle']                      = 'Search by most fields shown'

      #Uncomment for "Blue wonder" widget_list theme to see how to use this helper

=begin
      list_parms['rowOffsets']                       = ['#FFFFFF','#edf6fd']
      list_parms['headerBGColor']                    = '#3E88C9'
      list_parms['footerBGColor']                    = '#3E88C9'
      list_parms['headerFontColor']                  = '#FFFFFF'
      list_parms['footerFontColor']                  = '#FFFFFF'
      list_parms['borderedColumns']                  = true
      list_parms['borderColumnStyle']                = '1px solid #99BBE8'
      list_parms['tableBorder']                      = '1px solid #99BBE8'
=end

      return list_parms
    end
  end

end