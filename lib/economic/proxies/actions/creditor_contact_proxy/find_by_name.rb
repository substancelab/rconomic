module Economic
  module Proxies
    module Actions
      module CreditorContactProxy
        class FindByName
          attr_reader :name

          def initialize(caller, name)
            @caller = caller
            @name = name
          end

          def call
            # Get a list of CreditorContactHandles from e-conomic
            response = request('FindByName', {
              'name' => name
            })

            # Make sure we always have an array of handles even if the result only contains one
            handles = [response[:creditor_contact_handle]].flatten.reject(&:blank?)

            # Create partial CreditorContact entities
            contacts = handles.collect do |handle|
              creditor_contact = build
              creditor_contact.partial = true
              creditor_contact.persisted = true
              creditor_contact.handle = handle
              creditor_contact.id = handle[:id]
              creditor_contact.number = handle[:number]
              creditor_contact
            end

            if owner.is_a?(Creditor)
              # Scope to the owner
              contacts.select do |creditor_contact|
                creditor_contact.get_data
                creditor_contact.creditor.handle == owner.handle
              end
            else
              contacts
            end
          end

          private

          def build(*options)
            @caller.build(options)
          end

          def owner
            @caller.owner
          end

          def request(action, data)
            @caller.request(action, data)
          end
        end
      end
    end
  end
end
