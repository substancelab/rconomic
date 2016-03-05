# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

* Support for getting all contacts for a given debtor (@nielsbuus)
* Basic implementation of products (@traels)
* Ability to create CreditorInvoice entries (@prognostikos)
* Properties for "past due" status of invoices (@skelboe)
* Support to get company data (@adriacidre)
* Support X-EconomicAppIdentifier (@prognostikos)

### Changes

* The source code has a new home at https://github.com/substancelab/rconomic
* Non-existing methods removed from the documentation (@koppen)
* Handle Numbers can now be String as well as numbers (@traels)

### Removed

* We no longer officially support Ruby 1.9.3. rconomic might still work on
  legacy rubies, but we aren't testing it.
