grimwidgets
===========

## DESCRIPTION

The goal of this project is to develop a flexible framework
for handling graphical rich events in Legend of Grimrock
(http://grimrock.net) game. In particular, its goals are
support for:

- generic widgets, like buttons, dialogs, text elements etc.
- Powerfull api for making custom GUIs
- encounters with NPCs
- shops
- scripted events

## INSTALLATION

TODO

## Demo
The easiest way to see grimwidgets examples is to download working demo.
You can do this by going to [project webite|https://github.com/xanathar/grimwidgets]
and clicking [download|https://github.com/xanathar/grimwidgets/archive/master.zip] 
(the cloud button with ZIP written on it). It will download a zip file
that you should extract into your dungeons directory. Depending on your OS,
this will be:

- c:\Users\[login]\Documents\Almost Human\Legend of Grimrock\Dungeons (Windows)
- ~/Library/Application Support/Almost Human/Legend of Grimrock/Dungeons (Mac OS)
- ~/.local/share/Almost Human/Legend of Grimrock/Dugeons (Linux)

Start Dungeon Editor in Grimrock and open the project. There will be many buttons
and items. Play with them to see various aspects of grimwidgets. You can then
start looking into the scripts to see how specific features are achieved.

## Using grimwidgets

Grimwidgets is a powerful framework that allows Object Oriented
Programming (OOP) with object hierarchy and inheritance. Experienced
programmers will enjoy it a lot. On the other hand, an average modder
without programming background may not know what all that means, so
grimwidgets provides a number of very simple to use functions to achieve
common tasks, like displaying a yes/no popup.

## High Level (Easy) Interface
If you prefer ease of use, this is the interface for you. If you rather
prefer flexibility and andvanced features, see Low level interface in 
follow up sections below.


## Loe Level (Powerful) Interface
The most common reason to use grimwidgets is to display message popups.

To display a dialog box with a single OK button use the following function

    Dialog.quickDialog(text_to_display)

This will display the text with a single OK button. The window will disappear
when the user clicks OK. You can also pass additional parameter, which is a
function name. That function will be called when the user clicks ok.

    Dialog.quickDialog(text_to_display, function_name)

For example if you want to display a popup and once the window is closed, then
first party champion levels up. You could write the following code:

    function strangeMist()
	Dialog.quickDialog([[Your party approaches an eerie mist.
        One of you tries to touch it. Mist disappears and you feel englightened.]],
        clicked)
    end

    function clicked()
        party:getChampion(1):levelUp()
    end

Now you must make sure that the strangeMist() function is called at the appropriate
time. You can hook it to (potentially invisible) pressure plate, to timer, to
lever etc. Once the strangeMist() is triggered, it will display the dialog box.
You may note that the text is specified with double brackets. This is Lua way of 
defining multi-line strings. Once the user clicks ok, the clicked() command is called.
You can do whatever you want there - print out something, spawn new items, open doors
etc.

An example run of such a GUI:

[[doc/dialog-ok.png|Example fo Dialog.quickDialog(text, callback)]]


## Elements

- gw_element
- gw_button
- gw_button3D
- gw_rectangle

## General functions

TODO

## Developing your own widgets

TODO
