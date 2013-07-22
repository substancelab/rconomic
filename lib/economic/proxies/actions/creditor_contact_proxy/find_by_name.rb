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
            handles = [response[:creditor_contact_handle]].flatten.reject(&:blank?)
            contacts = build_partial_contact_entities(handles)
            scope_to_owner(contacts)
          end

          private

          def build(*options)
            @caller.build(options)
          end

          def build_partial_contact_entities(handles)
            handles.collect do |handle|
              creditor_contact = build
              creditor_contact.partial = true
              creditor_contact.persisted = true
              creditor_contact.handle = handle
              creditor_contact.id = handle[:id]
              creditor_contact.number = handle[:number]
              creditor_contact
            end
          end

          def owner
            @caller.owner
          end

          def request(action, data)
            @caller.request(action, data)
          end

          def response
            request('FindByName', {'name' => name})
          end

          def scope_to_owner(contacts)
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
        end
      end
    end
  end
end
