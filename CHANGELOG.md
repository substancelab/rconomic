# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

* Ability to create ManualDebtorInvoice cash book entries (@prognostikos).

### Changes

*

### Removed

*

## 0.7.1 [February 21st, 2018]

### Added

* Operation to fetch only current orders from the backend.
* Support for OrderLine objects (@olepalm)
* Ability to get order lines for a specific order (@olepalm).
* Orders can now be found by their other_reference field (@olepalm).
* Ability to toggle Sent-status of orders (@olepalm).

### Changes

* The cached E-conomic WSDL has been updated with the most recent version.

### Removed

## 0.7.0 [July 1st, 2018]

This release contains breaking changes as E-conomic has deprecated one of their connection methods. See https://www.e-conomic.com/developer#_ga=2.79896535.1117342868.1530474675-2146547048.1526554784 for details.

### Removed

* Ability to connect with agreement number, username and password. You need to use `Economic::Session#connect_with_token` going forward.
* Ability to set an app identifier. This was tied to the now removed `Economic::Session#connect_with_credentials` method.

## 0.6.1 [July 1st, 2018]

### Changes

* Tighten Savon dependency. Due to changes in Savons internal API we cannot work with versions 2.11.2 or later.

## 0.6.0 [April 30, 2017]

### Added

* Support for getting all contacts for a given debtor (@nielsbuus)
* Basic implementation of products (@traels)
* Ability to create CreditorInvoice entries (@prognostikos)
* Properties for "past due" status of invoices (@skelboe)
* Support to get company data (@adriacidre)
* Support X-EconomicAppIdentifier (@prognostikos)
* Fixed an issue where X-EconomicAppIdentifier wasn't set properly (@olepalm)

### Changes

* The source code has a new home at https://github.com/substancelab/rconomic
* Non-existing methods removed from the documentation (@koppen)
* Handle Numbers can now be String as well as numbers (@traels)
* Fixed authentication when using legacy Connect (@koppen)

### Removed

* We no longer officially support Ruby 1.9.3. rconomic might still work on
  legacy rubies, but we aren't testing it.
