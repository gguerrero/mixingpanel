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
