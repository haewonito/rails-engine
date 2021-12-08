class AddColumnsToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_column :invoiceitems, :quantity, :integer
    add_column :invoiceitems, :unit_price, :decimal, :scale => 2
  end
end
