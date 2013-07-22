module Economic
  module Proxies
    module Actions
      module DebtorContactProxy
        class FindByName
          attr_reader :name

          def initialize(caller, name)
            @caller = caller
            @name = name
          end

          def call
            # Get a list of DebtorContactHandles from e-conomic
            handles = [response[:debtor_contact_handle]].flatten.reject(&:blank?)
            contacts = build_partial_contact_entities(handles)
            scope_to_owner(contacts)
          end

          private

          def build(*options)
            @caller.build(options)
          end

          def build_partial_contact_entities(handles)
            handles.collect do |handle|
              debtor_contact = build
              debtor_contact.partial = true
              debtor_contact.persisted = true
              debtor_contact.handle = handle
              debtor_contact.id = handle[:id]
              debtor_contact.number = handle[:number]
              debtor_contact
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
              contacts.select do |debtor_contact|
                debtor_contact.get_data
                debtor_contact.debtor.handle == owner.handle
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
