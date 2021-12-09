class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  # def self.delete_empty_invoices
  #   joins(:invoice_items)
  #     .having('COUNT(invoice_items.id) = 1')
  #     .group(:id)
  #     .destroy_all
  # end

end
