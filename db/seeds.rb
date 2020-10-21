# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

Transaction.destroy_all
InvoiceItem.destroy_all
Invoice.destroy_all
Customer.destroy_all
Item.destroy_all
Merchant.destroy_all

starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

merchants = []
CSV.foreach('./app/csvs/merchants.csv', headers: true, header_converters: :symbol) do |data|
  merchants << Merchant.new(id: data[:id], name: data[:name], created_at: data[:created_at], updated_at: data[:updated_at])
end
Merchant.import(merchants)
ActiveRecord::Base.connection.reset_pk_sequence!('merchants')

items = []
CSV.foreach('./app/csvs/items.csv', headers: true, header_converters: :symbol) do |data|
  items << Item.new(id: data[:id], name: data[:name], description: data[:description], unit_price: (data[:unit_price].to_f / 100), merchant_id: data[:merchant_id], created_at: data[:created_at], updated_at: data[:updated_at])
end
Item.import(items)
ActiveRecord::Base.connection.reset_pk_sequence!('items')

customers = []
CSV.foreach('./app/csvs/customers.csv', headers: true, header_converters: :symbol) do |data|
  customers << Customer.new(id: data[:id], first_name: data[:first_name], last_name: data[:last_name], created_at: data[:created_at], updated_at: data[:updated_at])
end
Customer.import(customers)
ActiveRecord::Base.connection.reset_pk_sequence!('customers')

invoices = []
CSV.foreach('./app/csvs/invoices.csv', headers: true, header_converters: :symbol) do |data|
  invoices << Invoice.new(id: data[:id], customer_id: data[:customer_id], merchant_id: data[:merchant_id], status: data[:status], created_at: data[:created_at], updated_at: data[:updated_at])
end
Invoice.import(invoices)
ActiveRecord::Base.connection.reset_pk_sequence!('invoices')

invoice_items = []
CSV.foreach('./app/csvs/invoice_items.csv', headers: true, header_converters: :symbol) do |data|
  invoice_items << InvoiceItem.new(id: data[:id], item_id: data[:item_id], invoice_id: data[:invoice_id], quantity: data[:quantity], unit_price: (data[:unit_price].to_f / 100), created_at: data[:created_at], updated_at: data[:updated_at])
end
InvoiceItem.import(invoice_items)
ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')

transactions = []
CSV.foreach('./app/csvs/transactions.csv', headers: true, header_converters: :symbol) do |data|
  transactions << Transaction.new(id: data[:id], invoice_id: data[:invoice_id], credit_card_number: data[:credit_card_number], credit_card_expiration_date: data[:credit_card_expiration_date], result: data[:result], created_at: data[:created_at], updated_at: data[:updated_at])
end
Transaction.import(transactions)
ActiveRecord::Base.connection.reset_pk_sequence!('transactions')

ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
elapsed = ending - starting
puts "\nSuccess! Took #{elapsed.round(2)} seconds to seed the database.\n\n"
