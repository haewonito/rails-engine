class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def find_item_count(item)
    require "pry"; binding.pry
    # self.joins(invoices: :invoice_items)
    #   .where
    #   # SELECT COUNT(items.*)
    #   # FROM   invoice_items
    #   # JOIN   invoices
    #   # ON invoice_items.invoice_id = invoices.id
    #   # JOIN   items
    #   # ON invoice_items.item_id = items.id
    #   # WHERE invoices.id = 1;

  
  end
  # before_destroy :destroy_invoices
  #
  # private
  # #
  # def destroy_invoices
  #   self.invoices.delete_empty_invoices
  # end

#   def destroy_invoices!
# require "pry"; binding.pry
#
#   end



end
