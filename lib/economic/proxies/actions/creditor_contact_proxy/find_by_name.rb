require 'economic/proxies/actions/find_by_name'

module Economic
  module Proxies
    module Actions
      module CreditorContactProxy
        class FindByName < Actions::FindByName
          protected

          def handle_key
            :creditor_contact_handle
          end

          def scope_to_owner(contacts)
            if owner.is_a?(Creditor)
              contacts.select do |contact|
                contact.get_data
                contact.creditor == owner
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
