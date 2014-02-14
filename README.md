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
On a *CoffeeScript* from your choose, you should register and activate the mixingpanel trackings:

```Coffeescript
$ ->
  mixingpanel_tracker.activate()
  mixingpanel_tracker.register
    appname: "MyCoolApp"
    device_type: categorizr()
    user_logged_in: user_logged_in()
```

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
The source feature let you track <strong>3 cool superproperties</strong> within all your *mixpanel* *events*.
As this tracking is optional, you should manually append the source within your project after ```mixingpanel_tracker.activate()```. For example:

```coffeescript
$ ->
  mixingpanel_tracker.activate()
  mixingpanel_tracker.source.append()
```

This code will use the default behaviour for tracking sources, i.e:

* If *utm_campaign* appears in the URL params and the *utm_medium* param is different than 'email' the source will turn into **SEM**.
* If *utm_medium* is 'email', source will turn into **Email**.
* If the document referer is a search engine and there is no **UTM** params, the source turns into **SEO**.
* If the document referer is a social network, source come **Social**.
* If the document referer is another reference (but never from same domain), the source will be **Referral**.
* If there is no referer at all and none of the other conditions is true, the source turns into **Direct**.

As well as any company would like to have it's own way to track sources, you can provide new source mapping and a custom callback within the source is retrieved. For example:

```coffeescript
$ ->
  mixingpanel_tracker.source.appendSources
    SEM_PERMANENT: "SEM Permanent"
    SEM_EXPERIMENT: "SEM Experiment"
    SEO_GOOGLE: "SEO Google"
    SEO_OTHERS: "SEO Others"

  mixingpanel_tracker.source.setValueCallback ->
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

  mixingpanel_tracker.source.append()
```


<strong>Remember to implement all the sources values you want to return as you've override the defualt behaviour!!</strong>


The mixpanel superproperties tracked are:
* <strong>first_touch_source</strong> set the first user source on your site within an expiration of 30 days.
You can change this expiration days value by ```mixingpanel_tracker.source.expirationDays = 15```
* <strong>last_touch_source</strong> set the current user source on your site.
* <strong>source</strong> set and array of historical sources within the user navigation. This sources won't be repeated twice in a row, but it may be repeated along the source historical.


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
