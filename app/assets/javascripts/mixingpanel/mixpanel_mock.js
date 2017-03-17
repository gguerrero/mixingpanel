"use strict";
function MixPanelMock() {
  //Constructor
  var history = [];
  var mixpanelmock = {};

  mixpanelmock.getHistory = function(){
    return history;
  }

  mixpanelmock.track = function(eventString, props) {
    console.dir("this")
    this.addToHistory( {event: eventString, properties: props}, "track" );
  };

  mixpanelmock.register = function(props) {
  };
  mixpanelmock.unregister = function(props) {
  };
  mixpanelmock.track_links = function(selector, eventString, props) {
    var _this = this;
    $(selector).on("click", function(e){
      //if(_this.disableSubmitFlag == true) e.preventDefault()
      _this.addToHistory( { selector: selector, event:"Tracking link",  properties:props  }, "track_links" );
    });
  };
  mixpanelmock.track_forms = function(selector, eventString, props) {
    var _this = this;
    $(selector).on("submit", function(e){
      //if(_this.disableSubmitFlag == true) e.preventDefault()
      _this.addToHistory( { selector: selector, event:"Tracking form",  properties:props  }, "track_forms" );
    });
  };
  mixpanelmock.identify = function(id) {
  };
  mixpanelmock.preventNavigation = function(flag){
    // Navigation destroys mixpanel object so in order to stop navigation after event has been fired and captured accross all browsers
    // we user beforeunload sinc not all methods receive the event object to execute preventDefault() in the handler
    if(flag === true){
      window.onbeforeunload = function() {
        return 'Not allowed to navigate';
      };
    }else{
      window.onbeforeunload = undefined;
    }
  };
  mixpanelmock.addToHistory = function(obj, who){
    if(!who){
      who = "n/a";
    }
    console.log("("+who+") - adding to mixpanel mock history.");
    history.push(obj);
  };

  return mixpanelmock;
}

console.log("adding mixpanel to window!")
window.mixpanel = new MixPanelMock();