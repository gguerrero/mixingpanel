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
      
      special_opts = opts.slice!(:class, :id, :style, :data)
      opts = special_opts.merge(html: opts)

      form_for(record, opts, &block)
    end

    def tracked_form_tag(url, event, properties = {}, opts = {}, &block)
      opts[:class] = opts[:class].to_s + " trackme"

      opts[:data] = {} if opts[:data].nil?
      opts[:data].merge!({event: event, extra_props: properties.to_json})      
      
      form_tag(url, opts, &block)
    end

    if defined? SimpleForm
      def tracked_simple_form_for(record, event, properties = {}, opts = {}, &block)
        opts[:class] = opts[:class].to_s + " trackme"

        opts[:data] = {} if opts[:data].nil?
        opts[:data].merge!({event: event, extra_props: properties.to_json})

        simple_form_for(record, html: opts, &block)
      end
    end

  end
end

