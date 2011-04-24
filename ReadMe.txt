Hello,

Welcome to the source code for MatchHack. This project was designed to be run
via ANT in any ide or from the command line. Simply copy and rename
build.template.properties to build.properties, point FLEX_HOME to where you
keep your Flex SDK lives on your computer, run the build file then sit back
and enjoy the show.

Some build.properties values you may want to modify:

FLEX_HOME = this is the path to your Flex SDK. I was using version 4.5 for my
            builds, especially for mobile.
android.sdk = this is a pat to the android sdk folder. This allows the Ant build
            to deploy the apk to your device or emulator.
air.runtime.device = this is for installing the air run time during debugging.
browser - this is the browser you want to auto launch with, see below.
certificate.password - you will need to creat your own certificate. Delete mine
            in build/android-resources and the build will automatically generate
            you a new one.
deploy.loc = this represents where the fine files will be built to. By default
            I create a bin folder for you.


Configuring Browser For Auto Launch

The following is a chart of values to use on each OS to auto launch in a browser

Mac
Browser		Value
Safari		Safari
Firefox		FireFox
Chrome		'Google Chrome'

PC
Browser		Value
FireFox		C:/Program Files/Mozilla Firefox/firefox.exe


Notes for split up version:
The build script is split up into several files which are connected by the
build.xml in the project root.  All of the parts live in build/build-imports;
they are modules that accomplish specific parts of the build.  These modules
are included into the main file, which provides a bunch of exposed targets for
easier interaction with the modules. You can add your own build templates to
the folder and link them to the master build.xml. I will be adding support
for iOS and PlayBook very soon.

Assets & html templates
All of the assets compiled into the game can be found in the build/assets dir.
Same thing goes for the templates used to package up each build for web, air,
android etc. I also include a folder called promo with all the art for each
platform's market so you can get an idea of what you will need to launch your
own game.


