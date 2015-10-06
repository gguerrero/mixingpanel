# Mixingpanel

High level utilities for tracking events with *Mixpanel* in your Rails project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "mixingpanel", github: 'gguerrero/mixingpanel'
```

And then execute:

```bash
$ bundle
```


## Config
Run this generator to copy the config on your project initializers as ```mixingpanel.rb```.
```bash
$ rails generate mixingpanel:config
```

This config is based on the [official mixpanel configuration](https://mixpanel.com/help/reference/javascript-full-api-reference#mixpanel.set_config),
you can have a look at the allowed options.

Once you have your initializer installed you may want to change options:

```ruby
Mixingpanel.configure do |config|
  config.track_pageview         = false
  config.cross_subdomain_cookie = false
  config.cookie_name            = "third-party-mp"
  config.cookie_expiration      = 30
  config.track_links_timeout    = 100
end
```

*Remember to have a coherence between project options, otherwise the cookie may not be read between projects
and it will be a mess to discover why!*


## Usage

### Rendering
For insert the inline JS Mixpanel source code, add the following line on *application.html.erb*:

```rhtml
<%= include_mixpanel %>
```

Or if you're using HAML:

```haml
= include_mixpanel
```

### JS Include
For JS, in your *application.js* add the following line:

```javascript
//= require mixingpanel
```

### Environment
Set up the following **environment** **variables** on your project to deal with:

* Mixpanel Secret token:

```bash
MIXPANEL_SECRET_TOKEN="xxxxxxxxxxxxxxxxxx"
```


### Setup
On a *CoffeeScript* from your choose, you should initialize and bind the mixingpanel trackings:

```Coffeescript
$ ->
  mixingpanel_tracker = new MixingpanelTracker()
  mixingpanel_tracker.register
    appname: "MyCoolApp"
    device_type: categorizr()
    user_logged_in: user_logged_in()

  mixingpanel_tracker.bind()
```

Remember to setup this after the document is ready.


### Helpers
By using these *view* *helpers* you'll add all the data attributes required for the *Mixingpanel* JS to track event on your *Mixpanel* account.

* **Event** **tracker**, launched at *JQuery* document ready callback. Track as much events as you want to:

```rhtml
<%= event_tracker "Visit homepage", username: current_user.name %>
```

That will generate the following *HTML* code:

```html
<div class='mpevent trackme' style='display:none;' data-event='Visit homepage' data-extra-props='{"username":"William"}'></div>
```

* **Link** **tracker**, tracks the event when the link is clicked:

```rhtml
<%= tracked_link_to 'Read Me!', '/readme', 'Click on ReadMe', {username: current_user.name}, {class: "button"} %>
```

That will generate the following *HTML* code:

```html
<a href='/readme' class='button trackme' id='tracked_item_1382331238331' data-event='Click on ReadMe' data-extra-props='{"username":"William"}'>
Read Me!
</a>
```

* **Form** **tracker**, tracks the event when the form is submited:

```rhtml
<%= tracked_form_for @user, 'Submit user', {admin: current_user.admin?}, {class: "cool_form"} do |f| %>
  <% f.text_field ... %>
  <% f.text_field ... %>
  <% f.text_field ... %>
<% end %>
```

That will generate the following *HTML* code:

```html
<form accept-charset="UTF-8" action="/users/2/edit" class="cool-form" id="tracked_item_138576212213312" method="post" data-event='Submit user' data-extra-props='{"admin":"True"}'>
 <...>
 <...>
 <...>
</form>
```


## Track your Sources!
The source feature tracks <strong>2 cool superproperties</strong> within all your *mixpanel* *events*.
The default behaviour for tracking sources is:

* If *utm_campaign* appears in the URL params and the *utm_medium* param is different than 'email' the source will turn into **SEM**.
* If *utm_medium* is 'email', source will turn into **Email**.
* If the document referer is a search engine and there is no **UTM** params, the source turns into **SEO**.
* If the document referer is a social network, source come **Social**.
* If the document referer is another reference (but never from same domain), the source will be **Referral**.
* If there is no referer at all and none of the other conditions is true, the source turns into **Direct**.

As well as any company would like to have it's own way to track sources, you can provide new source mapping and a custom callback within the source is retrieved when the tracker is initialized. For example:

```coffeescript
$ ->
  mpp = new MixingpanelTracker
    source:
      values:
        SEM_PERMANENT: "SEM Permanent"
        SEM_EXPERIMENT: "SEM Experiment"
        SEO_GOOGLE: "SEO Google"
        SEO_OTHERS: "SEO Others"
      callback: ->
        if @utm.campaign is "sem_permanent"
          @sources.SEM_PERMANENT
        else if @utm.campaign is "sem_experiment"
          @sources.SEM_EXPERIMENT
        else if @utm.medium is "email"
          @sources.EMAIL
        else if @properties.engine?
          if @properties.engine is "google"
            @sources.SEO_GOOGLE
          else
            @souces.SEO_OTHERS
        else if @properties.referer != ""
          if @properties.isSocial()
            @sources.SOCIAL
          else
            @sources.REFERRAL
        else if @properties.referer is ""
          @sources.DIRECT
        else
          undefined

  mpp.bind()
```

If you don't want to automatically append sources on *MixingpanelTracker* initializer, you could do so with:

```coffeescript
$ ->
  mpp = new MixingpanelTracker
    source:
      append: false

  # ...
  # DO SOME STUFF
  # ...

  mpp.source.append()
  mpp.bind()
```


<strong>Remember to implement all the sources values you want to return as you've override the default behaviour!!</strong>


The mixpanel superproperties tracked are:
* <strong>first_touch_source</strong> set the first user source on your site within an expiration of 30 days.
You can change this expiration days value by
```coffeescript
  mpp = new MixingpanelTracker
    source:
      firstTouchExpirationDays: 15
```
* <strong>last_touch_source</strong> set the current user source on your site.

As extra properties for **debug** aim:
* <strong>first/last_touch_timestamp</strong> set the timestamp in the moment of the tracking.
* <strong>last_touch_utm_*</strong> set the ```utm``` parameters extracted from the URL.

### Custom referring domain exceptions
If you need to track/set a source in specials cases, even the fact that the referring domain is internal, you can add a list of whitelisted referring domains:

```coffeescript
  mpp = new MixingpanelTracker
    source:
      referringDomainExceptions:
      	[ 'foo.bar.org',
      	  'baz.bar.org',
      	  'meh.bar.org' ]
```

**DO NOT SET IN ANY CASE YOUR OWN DOMAIN ('bar.org' on the example case) OR THE SOURCE WILL BE RECALCULATED ON EVERY PAGE VISIT**

## Appending *body data attributes*
By default *Mixingpanel* will append the body data attributes under 'mp' *on every track*, i.e:
```javascript
$('body').data('mp');
```

You may set different mixpanel properties from your controller or views by using the helpers provided on the gem ```add_mixpanel_attributes```, or by manually set the variables ```@mp_section```, ```@mp_owner```, ```@mp_product```, ```@mp_subproduct```, ```@mp_item``` and ```@mp_extras```.

So, in your *application.html* add this:
```HTML+ERB
<body data="<%= { mp: global_mixpanel_attributes } %>">
  ...
</body>
```

And on your views and on your controllers:
```ruby
class ApplicationController
  include MixingpanelHelper
end

class UserController < ApplicationController
  def index
    add_mixpanel_attributes section: "home",
                            owner: "seo",
                            product: "insurances",
                            subproduct: "car insurance",
                            foo: "bar"
  end
end
```

or
```ruby
def index
  @mp_section    = "home"
  @mp_owner      = "seo"
  @mp_product    = "insurances"
  @mp_subproduct = "car insurance"
  @mp_extras     = {foo: "bar"}
end
```

You can even retrieve any of the already set properties with:
```ruby
  mixpanel_attributes
  mixpanel_attributes[:product]
  mixpanel_attributes[:item]
```

#### Turning off the global properties append
If you don't want to auto append all this properties on your events add the following config on your ```Mixingpanel``` initializer:

```coffeescript
$ ->
  mpp = new MixingpanelTracker
    appendGlobals: false

  # ...
  # DO SOME STUFF
  # ...

  mpp.bind()
```

## Tracking URL params
This functionality allows you to track URL params as properties on any event.
You may create a whitelist of the URL parameters you allow to be tracked.
Something you may know about **tracking params**:

- They will be only be tracked if these params come from an external source, i.e, any source not from your own domain.
- They will stop tracking after you visit your site from another external source that do not contains those params (the cookie that contains the params will be deleted).
- These params will override any other property named equal. So keep in mind that any other tracking that contains a property with the same name that a tracking param, that value, will be written by the value on the **tracking params cookie**.

To setup your params whitelist you should add them on the **tracker** initializer like this:

```Coffeescript
  mpp = new MixingpanelTracker
    tracking_params: ['foo', 'bar', 'baz']
```

## Tracking properties priority!!
**Be careful at this point**, there are many ways of tracking properties, but they will be merged in order, so maybe you'll find some of then are been override and you won't know why. Properties tracking order is:

1. [Global body attributes](#appending-body-data-attributes)
2. [Other properties](#helpers)
3. [Tracking URL params](#tracking-url-params)

For example, you're tracking a property that is already on ```$('body').data().mp``` attributes:

```Coffeescript
$('body').data.mp
=> Object {foo: 'bar'}

@mixingpanel_tracker.track('Visit page', foo: 'foo')
```

In the case above, you'll get **foo** property with *bar* value on Mixpanel, because the **Global body attributes** have a more important priority on tracking.
Same way will happen with **tracking URL params**.


## Custom sessions using mixpanel superproperty

You can create a custom session which use mp_session_id superproperty using the query param ```mp_session_start=YOURSESSIONID``` in the url.

This is useful when you are doing tests and want to regroup all your tracking in multiple devices. You can close the custom session with the query param ```mp_session_end=ANY```.


## Running *Jasmine* test suite
As these code is writed on [CoffeScript](http://coffeescript.org/), the *Jasmine* test suite requieres to compile all the specs, source files, helper files and fixtures to JS first, so that's why *[jasmine/compiler.rb](https://github.com/gguerrero/mixingpanel/blob/master/lib/jasmine/compiler.rb)* exists. See also [Pivotal CI solution](http://pivotallabs.com/writing-and-running-jasmine-specs-with-rails-3-1-and-coffeescript/)

To run the Jasmine test suite server:

```bash
$ rake jasmine:coffee
```

To run the Jasmine test suit as CI:

```bash
$ rake jasmine:ci:coffee
```

## ToDo
* Add **rspec** test for testing Rails helpers.

## License
This project uses [*MIT-LICENSE*](http://en.wikipedia.org/wiki/MIT_License).
