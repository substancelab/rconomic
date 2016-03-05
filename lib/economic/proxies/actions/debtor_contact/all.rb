module Economic
  module Proxies
    module Actions
      module DebtorContact
        class All
          def initialize(caller)
            @caller = caller
            @session = caller.session
          end

          def call
            build_partial_contact_entities(handles_from_endpoint)
          end

          private

          def build(*options)
            @caller.build(options)
          end

          def build_partial_contact_entities(handles)
            handles.collect do |handle|
              contact = build
              contact.partial = true
              contact.persisted = true
              contact.handle = handle
              contact.id = handle[:id]
              contact.number = handle[:number]
              contact
            end
          end

          def handles_from_endpoint
            [response[handle_key]].flatten.reject(&:blank?)
          end

          def handle_key
            (Support::String.underscore(@caller.class.entity_class_name) + "_handle").to_sym
          end

          def owner
            @caller.owner
          end

          def request(action, data)
            @session.request(
              soap_action_name("Debtor", action),
              data
            )
          end

          def response
            request("get_debtor_contacts", {"debtorHandle" => {"Number" => owner.number}})
          end

          def soap_action_name(entity_class, action)
            Endpoint.new.soap_action_name(entity_class, action)
          end
        end
      end
    end
  end
end
