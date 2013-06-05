class Item
  include Mongoid::Document
  field :name, type: String
  field :price, type: Float, default: 0.40
  field :date_added, type: Date, default: Time.now
  field :sku, type: Integer, default: 1000
  field :active, type: String, default: 'Yes'
end
