## 0.0.1 (November, 2013)

* initial release.

## 0.8.0 (November 28, 2013)

* Rails helpers ready.
* Tracker and Properties ready.
* Jasmine test running and passing.
* Readme instructions.

## 0.8.5 (November 29, 2013)

* Improve more the README text

## 0.9.1 (December 20, 2013)

* Remove the security section. Each app should securize itself the way to use the gem.

## 0.9.2 (January 03, 2014)

* Add helper for 'simple_form' gem.
* Add 'pageType' method on Properties class.

## 0.10.0 (January 04, 2014)

* Update 'README.md'.
* Improve the way that the class is loaded. Domain is not needed anymore to activate the class.

## 0.10.1 (January 04, 2014)

* Fix 'tracked_form_for' helper so special options are splitted from html options

## 0.11.1 (January 20, 2014)

* Add SEM type!
* Remove ```jquery``` dependency

## 0.12.0 (February 14, 2014)

* Add source feature to track first and last touch of a user, as well as it's source history.

## 0.14.0 (March 5, 2014)

* First touch source datetime new superproperty: Expiration time for first touch controled with this new property.

## 0.20.0 (March 6, 2014)

* Mixingpanel Tracker new constructor!! Object is created outside the Gem JS files.
* HTML Tags are binded manually after object build. So source can be appended before any event is tracked.

## 0.21.0 (March 6, 2014)

* Source is appended by default.
* Sources and source callback may be modified from tracker builder.

## 0.22.0 (March 10, 2014)

* Lots of fun tracking new super-properties. Now first and last touch sources
will include a bunch of superproperties in addition to 'source' itself. The aim is to debug
what were the data comming with each first and last superproperty in every moment.

## 0.23.0 (March 20, 2014)

* Pack all superproperties in a object and call mixpanel.register only once
* Remove some not used debug properties

## 0.24.0 (April 3, 2014)

* Remove 'source' property to not overload cookies with the array

## 0.25.0 (May 14, 2014)

* Add 'cookies' management interface
* Use a cookie to manage first touch timestamp. That prevent from using the mixpanel
'get_property' function! Finally!!

## 0.26.0 (May 19, 2014)

* Add 'tracked_form_tag' helper

## 0.28.0 (May 20, 2014)

* Renable cookies new functionality and remove session param from cookie set

## 0.29.0 (Jun 12, 2014)

* Add callback on ```track``` main core function

## 0.30.0 (Jul 03, 2014)

* Add UTM params and location URL to last/first touch sources

## 0.30.1 (Jul 09, 2014)

* Set UTM Params to 'null' for overriding source properties if UTM are not present.

## 0.30.2 (Jul 09, 2014)

* Set location and referrer sources to 'null' for overriding source properties if those are not present.

## 0.30.3 (Oct 21, 2014)

* Return 'true' on each document element iteration when tracking so the loop will continue until the last element

## 0.31.0 (Nov 5, 2014)

* The moment is here! Carte blanche on all the sources as google analytics does :)

## 0.40.0 (Oct 16, 2014)

* Body data 'mp' attributes are append as properties to all the tracked events by default
* Ability to turn of/on auto global properties append on *MixingpanelTracker*

## 0.41.0 (Mar 3, 2015)

* New getter for mixpanel attributes: ```mixpanel_attributes```

## 0.42.0 (Mar 9, 2015)

* Remove some ```first_touch_*``` superproperties to avoid cookie overflow.

## 0.43.0 (Mar 9, 2015)

* **NO RAILS DEPENDENCY!**

## 0.44.0 (Mar 11, 2015)

* Less 'last_touch' superproperties in order to no overflow cookies.

## 0.45.0 (Mar 11, 2015)

* Mixpanel Init function receive options.
* Rails configuration for Mixingpanel.
* Mixingpanel generator for initialize configuration.

## 0.46.0 (Jul 29, 2015)

* Allow to init custom sessions from url querystring.

## 0.47.0 (Jul 30, 2015)

* Source is setted now if referring domain is on a exception list.
* Referring domain exception list can be configure on initialization.

## 0.47.1 (Aug 3, 2015)

* Source '_setUTM' now can receive query string object as param, so from 'value'
callback, that function can be used in some special cases.

## 0.48.0 (Oct 06, 2015)

* Tracking whitelist parameters.
* Config whitelist engagement.
* Cookie store for whitelisted params.
* Tracked params always override other params if there is a match on name.

## 0.50.0 (Oct 07, 2015)

* External domains are now listed as a generic options
* Options are now managed on a window level object

## 0.60.0 (Dic 01, 2015)

* Add 'last_touch_start_session' to determine wether 'last_touch_*' attributes did track first time.
* Add tests for source properties including 'last_touch_start_session'.

## 0.60.2 (Mar 17, 2017)

* Escape regexp for internal domain checking

