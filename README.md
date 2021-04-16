r-conomic
=========

Ruby wrapper for the [e-conomic](http://www.e-conomic.co.uk) SOAP API, that aims at making working with the API bearable.

E-conomic is a web-based accounting system. For their marketing speak, see [http://www.e-conomic.co.uk/about/](http://www.e-conomic.co.uk/about/). More details about their API at [http://www.e-conomic.com/developer](http://www.e-conomic.com/developer).

[![Build Status](https://travis-ci.org/substancelab/rconomic.svg?branch=master)](https://travis-ci.org/substancelab/rconomic) [![Test Coverage](https://codeclimate.com/github/substancelab/rconomic/badges/coverage.svg)](https://codeclimate.com/github/substancelab/rconomic/coverage) [![Code Climate](https://codeclimate.com/github/substancelab/rconomic/badges/gpa.svg)](https://codeclimate.com/github/substancelab/rconomic)


Usage example
-------------

    economic = Economic::Session.new

    # Connect using a Private app ID and an access ID provided by the "Grant Access"
    # As described here: https://www.e-conomic.com/developer/connect
    economic = Economic::Session.new
    economic.connect_with_token 'the_private_app_id', 'the_access_id_you_got_from_the_grant'

    # Find a debtor:
    debtor = economic.debtors.find(:number => 101)

    # Creating a debtor:
    debtor = economic.debtors.build

    debtor.number = economic.debtors.next_available_number
    debtor.debtor_group_handle = { :number => 1 }
    debtor.name = 'Bob'
    debtor.vat_zone = 'HomeCountry' # HomeCountry, EU, Abroad
    debtor.currency_handle = { :code => 'DKK' }
    debtor.price_group_handle = { :number => 1 }
    debtor.is_accessible = true
    debtor.ci_number = '12345678'
    debtor.term_of_payment_handle = { :id => 1 }
    debtor.layout_handle = { :id => 16 }
    debtor.save

    # Create invoice for debtor:
    current_invoice = debtor.current_invoices.build
    current_invoice.term_of_payment_handle = debtor.term_of_payment_handle

    current_invoice.date = Time.now
    current_invoice.due_date = Time.now + 15
    current_invoice.exchange_rate = 100
    current_invoice.is_vat_included = false

    invoice_line = Economic::CurrentInvoiceLine.new
    invoice_line.description = 'Line on invoice'
    invoice_line.unit_handle = { :number => 1 }
    invoice_line.product_handle = { :number => 101 }
    invoice_line.quantity = 12
    invoice_line.unit_net_price = 19.95
    current_invoice.lines << invoice_line

    current_invoice.save

    # You can delete it by doing:
    # current_invoice.destroy

    invoice = current_invoice.book

    # Create a debtor payment

    cash_book = economic.cash_books.all.last # Or find it by its number

    # The reason debtor payments are done this way is because we don't want to specify the voucher number. If we build the cash book entry ourselves,
    # without specifying the voucher number, the API will complain. This way, E-Conomics will assign a voucher number for us.

    cash_book_entry = cash_book.entries.create_debtor_payment(:debtor_handle => debtor.handle, :contra_account_handle => { :number => '1920' })
    cash_book_entry.amount = -123.45
    cash_book_entry.currency_handle = { "Code" => "DKK" }
    cash_book_entry.debtor_invoice_number = invoice.number
    cash_book_entry.text = "Payment, invoice #{ invoice.number }"
    cash_book_entry.save

    cash_book.book

    # Find a product:
    product = economic.products.find(1234)

    # Creating a product:
    product = economic.products.build
    product.number = 'ESC2014-LED-DISPLAY'
    product.product_group_handle = { :number => 1 }
    product.name = '100 meter LED display'
    product.sales_price = 999999
    product.cost_price = 100000
    product.recommended_price = 999999
    product.is_accessible = true
    product.volume = 1
    product.save

How to enable e-conomic API access
----------------------------------

You need a Developer account and setup an app in their web UI. E-conomic users can then grant that app access to their account.

* Developer portal: https://www.e-conomic.com/developer
* Instructions: https://www.e-conomic.com/developer/connect

It doesn't do everything
------------------------

Not even remotely... For now, limited to a small subset of all the [available operations](https://www.e-conomic.com/secure/api1/EconomicWebService.asmx):

                       | Create | Read | Update | Delete
    -------------------+--------+------+--------+-------
    CashBook           | X      | X    | X      | X
    CashBookEntry      | X      | X    | X      | X
    Company            | X      | X    | X      | X
    Creditor           | X      | X    | X      | X
    CreditorEntry      | X      | X    |        |
    CreditorContact    | X      | X    | X      | X
    CreditorEntry      | X      | X    | X      | X
    CurrentInvoice     | X      | X    | X      | X
    CurrentInvoiceLine | X      | X    | X      | X
    Debtor             | X      | X    | X      | X
    DebtorContact      | X      | X    | X      | X
    DebtorEntry        | X      | X    | X      | X
    Entry              | X      | X    | X      | X
    Invoice            | X      | X    |        |
    Order              |        | X    |        |
    OrderLine          |        | X    | X      |
    Product            | X      | X    | X      | X

Credits
-------

Sponsored by [Lokalebasen.dk](http://lokalebasen.dk)


License
-------

R-conomic is licensed under the MIT license. See LICENSE for details.
