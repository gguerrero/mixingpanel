# Mixingpanel

High level utilities for tracking events with *Mixpanel* in your Rails project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "mixingpanel", git: 'gguerrero/mixingpanel'
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

* Filtered IPs. The addreses that won't track to mixpanel:

```bash
MIXPANEL_FILTERED_IPS="127.0.0.1 10.114.2.23 xxx.xxx.xx.xxx"
```

* Give temporary access to tracking into mixpanel, without IPs restrictions:

```bash
MIXPANEL_TEMP_ACCESS=Yes/No
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
