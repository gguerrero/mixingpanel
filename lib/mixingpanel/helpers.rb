module Mixingpanel
  module ViewHelpers

    def include_mixpanel
      render 'mixpanel/mixpanel'
    end

    def event_tracker(event, properties = {})
      content_tag(:div, nil, class: 'mpevent trackme', style: 'display: none;', 
                  data: {event: event, extra_props: properties.to_json})
    end

    def tracked_link_to(name, path, event, properties = {}, opts = {}, &block)
      path, event, properties, opts = name, path, event, properties if block_given?
      opts[:class] = opts[:class].to_s + " trackme"

      opts[:data] = {} if opts[:data].nil?
      opts[:data].merge!({event: event, extra_props: properties.to_json})

      block_given? ? link_to(path, opts, &block) : link_to(name, path, opts)
    end

    def tracked_form_for(record, event, properties = {}, opts = {}, &block)
      opts[:class] = opts[:class].to_s + " trackme"

      opts[:data] = {} if opts[:data].nil?
      opts[:data].merge!({event: event, extra_props: properties.to_json})      
      
      form_for(record, opts, &block)
    end

  end
end