module Economic
  module Proxies
    module Actions
      class FindByName
        attr_reader :name

        def initialize(caller, name)
          @caller = caller
          @name = name
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
          :handle
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
          contacts
        end
      end
    end
  end
end
