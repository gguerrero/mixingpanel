module MixingpanelHelper
  def mixpanel_attributes
    { section:    @mp_section,
      owner:      @mp_owner,
      product:    @mp_product,
      subproduct: @mp_subproduct,
      item:       @mp_item }.merge(@mp_extras || {})
  end

  def global_mixpanel_attributes
    mixpanel_attributes.reject{|k,v| v.blank?}.to_json
  end

  def add_mixpanel_attributes(attrs)
    @mp_extras ||= {}
    @mp_extras.merge!(attrs)
  end
end
