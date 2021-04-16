# frozen_string_literal: true

require "economic/proxies/entity_proxy"
require "economic/proxies/actions/find_by_date_interval"
require "economic/proxies/actions/find_by_handle_with_number"

module Economic
  class OrderProxy < EntityProxy
    include FindByDateInterval
    include FindByHandleWithNumber

    # Fetches all current orders from the API.
    def current
      response = request(:get_all_current)
      handles = response.values.flatten.collect { |handle| Entity::Handle.build(handle) }
      initialize_items
      get_data_for_handles(handles)

      self
    end

    def find_by_other_reference(reference)
      response = request(:find_by_other_reference, "otherReference" => reference)

      handle_key = "#{Support::String.underscore(entity_class_name)}_handle".intern
      handles = [response[handle_key]].flatten.reject(&:blank?).collect do |handle|
        Entity::Handle.build(handle)
      end

      get_data_array(handles).collect do |entity_hash|
        entity = build(entity_hash)
        entity.persisted = true
        entity
      end
    end

    def find(handle)
      if handle.is_a?(Hash)
        super handle
      else
        super({id: handle})
      end
    end
  end
end
