module Economic
  module Proxies
    module Actions
      class FindByName
        attr_reader :name

        def initialize(caller, name)
          @caller = caller
          @name = name
          @session = caller.session
        end

        def call
          contacts = build_partial_contact_entities(handles_from_endpoint)
          scope_to_owner(contacts)
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
            Endpoint.new.soap_action_name(@caller.entity_class, action),
            data
          )
        end

        def response
          request("FindByName", {"name" => name})
        end

        def scope_to_owner(contacts)
          if owner.is_a?(Session)
            contacts
          else
            owner_type = Support::String.underscore(
              Support::String.demodulize(owner.class.name)
            )
            contacts.select do |contact|
              contact.get_data
              contact.send(owner_type) == owner
            end
          end
        end
      end
    end
  end
end
