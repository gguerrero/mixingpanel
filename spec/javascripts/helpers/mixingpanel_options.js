window.setMixingpanelOptions = function (options) {
  defaultOptions = {
    internal_domain: undefined,
    external_domains: [],
    tracking_params: [],
    source: {}
  };
  window.mixingpanel_options = $.extend({}, defaultOptions, options);
};

// Default initialization
setMixingpanelOptions({});
