module Economic
  class DebtorProxy
    attr_reader :session

    def initialize(session)
      @session = session
    end

    # Returns a new, unpersisted Economic::Debtor
    def build
      debtor = Economic::Debtor.new
      debtor.session = session
      debtor
    end

    # Gets data for Debtor from the API
    def find(number)
      debtor_hash = session.request Debtor.soap_action(:get_data)  do
        soap.body = {
          'entityHandle' => {
            'Number' => number
          }
        }
      end
      debtor = Debtor.new(debtor_hash)
      debtor.session = self.session
      debtor.persisted = true
      debtor
    end

    # Returns Debtors that have the given ci_number. The Debtor objects will only be partially loaded
    def find_by_ci_number(ci_number)
      # Get a list of DebtorHandles from e-conomic
      response = session.request Debtor.soap_action('FindByCINumber') do
        soap.body = {
          'ciNumber' => ci_number
        }
      end

      # Make sure we always have an array of handles even if the result only contains one
      handles = [response[:debtor_handle]].flatten.reject(&:blank?)

      # Create partial Debtor entities
      handles.collect do |handle|
        debtor = Debtor.new
        debtor.session = session
        debtor.persisted = true

        debtor.handle = handle
        debtor.number = handle[:number]

        debtor
      end
    end

    # Returns the next available debtor number
    def next_available_number
      session.request Debtor.soap_action(:get_next_available_number)
    end
  end
end