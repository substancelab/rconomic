require 'economic/proxies/actions/find_by_name'

module Economic
  module Proxies
    module Actions
      module DebtorContactProxy
        class FindByName < Actions::FindByName
          protected

          def handle_key
            :debtor_contact_handle
          end

          def scope_to_owner(contacts)
            if owner.is_a?(Debtor)
              contacts.select do |contact|
                contact.get_data
                contact.debtor == owner
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
