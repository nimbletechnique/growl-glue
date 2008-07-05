== DESCRIPTION:

Simplifies Growl configuration for Autotest.

== Autotest Features:

* Easy configuration of growl notifications in ~/.autotest
* Comes bundled with sample green/red images, or you can supply your own
* Ability to specify OS X speech options (e.g. "Oh No!", if test failure)
* RSpec support
* Test::Unit support

== Autotest Growl Integration:

The Autotest growl configuration should happen in ~/.autotest. To get up and running very quickly with basic notifications + images:

  require 'growl_glue'
  GrowlGlue::Autotest.initialize

  
If you wish to customize, further, you simply need to supply your own block, to which the GrowlGlue configuration object will be passed:

  require 'growl_glue'
  GrowlGlue::Autotest.initialize do |config|
    ...
  end

It is recommended that you use network notifications due to a bug in Growl on OS X 10.5. Inside of the Growl Preferences pane, on the Network tab, make sure the "Listen for incoming notifications" checkbox is checked, and then *restart Growl*.  Then configure GrowlGlue inside of the setup block:

  config.notification :use_network_notifications => true

OS X Speech:

  config.say :success => "Great Job!", :failure => "WTF mate?"

If you have *sndplay* compiled and in the path, you can have different sounds played based on test success or failure.  The "location" below is optional, as it defaults to "/System/Library/Sounds":

  config.sound :success => "Glass.aiff"
  config.sound :failure => "Basso.aiff"
  config.sound :location => "/System/Library/Sounds/" (optional)

GrowlGlue comes with success and error images it will use on test success and error, respectively.
If you wish to supply your own, for example:

  config.image :success => "~/Library/autotest/success.png"
  config.image :failure => "~/Library/autotest/failure.png"

By default, "Tests Passed" and "Tests Failed" will be used as the growl titles. You can supply your own, though:

  config.title :success => "Love", :failure => "Hatred"

As an example, this is what I normally use:

  GrowlGlue::Autotest.initialize do |config|
  
    config.notification :use_network_notifications => true
    config.title :success => "Love", :failure => "Hate"
    config.say :failure => "Something is horribly wrong!"
  
  end


== REQUIREMENTS:

* Growl 1.1.4 (may work on previous versions but not tested)
* Growlnotify Extra installed

== OPTIONAL:

* sndplay (for #sound notification)

== INSTALL:

* sudo gem install growl-glue
* Download Growl from http://growl.info
* After installing Growl, install the Growlnotify Extra included in the DMG
* After Growl is installed, configure your ~/.autotest file as described above

== BUGS / ISSUES:

Please let me know (gluedtomyseat@gmail.com) if you encounter any issues.  You can also follow or fork development on the github project:

http://github.com/oculardisaster/growl-glue/tree/master


== LICENSE:

(The MIT License)

Copyright (c) 2008 Nimble Technique, LLC

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
