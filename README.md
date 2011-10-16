r-conomic
=========

Ruby wrapper for the [e-conomic](http://www.e-conomic.co.uk) SOAP API, that aims at making working with the API bearable.

E-conomic is a web-based accounting system. For their marketing speak, see [http://www.e-conomic.co.uk/about/](). More details about their API at [http://www.e-conomic.co.uk/integration/integration-partner/]().


Usage example
-------------

    economic = Economic::Session.new(123456, 'API', 'passw0rd')
    economic.connect
    
    # Find a debtor:
    debtor = economic.debtors.find(101)
    
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
    invoice = economic.current_invoices.build
    invoice.date = Time.now
    invoice.due_date = Time.now + 15
    invoice.exchange_rate = 100
    invoice.is_vat_included = false
    
    invoice_line = Economic::CurrentInvoiceLine.new
    invoice_line.description = 'Line on invoice'
    invoice_line.unit_handle = { :number => 1 }
    invoice_line.product_handle = { :number => 101 }
    invoice_line.quantity = 12
    invoice_line.unit_net_price = 19.95
    invoice.lines << invoice_line
    
    invoice.save
    
    # Delete it again
    invoice.destroy


How to enable e-conomic API access
----------------------------------

You need to enable API access in e-conomic before you can, well, use the API. Otherwise you'll be getting access denied errors when connecting.

Just follow the instructions on [e-copedia](http://wiki.e-conomic.co.uk/add-on-modules/) to enable the API Add-on module.


It doesn't do everything
------------------------

Not even remotely... For now, limited to a small subset of all the [available operations](https://www.e-conomic.com/secure/api1/EconomicWebService.asmx):

                       | Create | Read | Update | Delete
    -------------------+--------+------+--------+-------
    CurrentInvoice     | X      | X    | X      | X
    CurrentInvoiceLine | X      | X    | X      | X
    Debtor             | X      | X    | X      | X
    DebtorContact      | X      | X    | X      | X


Credits
-------

Sponsored by [Lokalebasen.dk](http://lokalebasen.dk)
