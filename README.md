grimwidgets
===========

Written by Xanathar, JKos, Thomson. Includes large chunks of
code written by Mahric.

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

### Simple dialog box
To display a dialog box with a single OK button use the following function

    Dialog.quickDialog(text_to_display)

This will display the text with a single OK button. The window will disappear
when the user clicks OK. You can also pass additional parameter, which is a
function name. That function will be called when the user clicks ok.

    Dialog.quickDialog(text_to_display, function_name)

#### Simple dialog box example

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

![](https://raw.github.com/xanathar/grimwidgets/master/doc/dialog-ok.png)

### Yes/No Dialog
It is useful to ask a simple yes/no questions and get user's response. You can
create such a dialog using the following functions:

    dialogId Dialog.quickYesNoDialog(text, callback, npcId)

text specifies text to display, callback is a name of the function that will be
called after user clicks something. npcId is an optional Non-Player Character (NPC)
identifier if you use NPC module. You can specify nil here if you don't want to
use it.

Once the dialog is created, it is not displayed yet. It can be displayed using
the following call:

    Dialog.activate(dialogId, callback)

Make sure you pass dialogId returned by Dialog.quickYesNoDialog here.

#### Yes/No dialog example
Here's an example dialog to test player's courage:

    function yesNoQuestion()
        local dialogId = Dialog.quickYesNoDialog("Hey! Are you brave?", callback, nil)
        Dialog.activate(dialogId, calback)
    end

    function callBack(answer)
        if answer == "Yes" then
            hudPrint("Yeah, right...")
        end
        if answer == "No" then
            hudPrint("Run for your life! There's killer snail after you")
        end
    end

![](https://raw.github.com/xanathar/grimwidgets/master/doc/dialog-yes-no.png)

### Dialog box with custom buttons

It is often useful to let the user make a decision or ask about something.
This is slightly more complicated and requires couple steps:

    dialogId Dialog.new(text, buttonText, npcId)
    
text is a text to be displayed. buttonText is the text on a first button.
npcId is an optional parameter that specify Non-Player Character (NPC) identifier.
It is only usable if you also use NPC module. If not using NPCs, specify nil here.
This method returns dialogId. Make sure you store it in a variable, because
you'll need it to add other buttons or show the dialog.

Now you can add additional buttons using the following call:

    Dialog.addButton(dialogId, buttonText)
    
Once you have added all buttons, you can display the window:

    Dialog.activate(dialogId, callback)
    
This will display dialog specified by dialogId (as returned by Dialog.new())
and will call callback function after the user clicks one of the buttons.

#### Dialog box with custom buttons example
Let's imagine a case where user meets a big ogre and he asks the party to leave. The
options would be to apologize and or insult the ogre. The following code can be used
to achieve that goal:

    agree ="I'm going already!"
    refuse = "Right, make me!"

    function clickOgre()
        local text = "Hey! What are you doing here? Leave while you can!"
        
        -- This created a new dialog with text written on it and a single 
        -- button that has value of agree variable written on it
        local dialogId = Dialog.new(text, agree, nil)
        
        -- Add another button that will challenge the ogre
        Dialog.addButton(dialogId, refuse)
        
        -- Display our dialog and call clicked method when user chooses something
        Dialog.activate(Dialog, clicked)
    end

    fucntion clicked(clickedText)
    	if clickedText == agree then
    	    hudPrint("Party if full of chickens!")
    	end
    	if clickedText == refuse then
    	    hudPrint("Ogre is now furious!")
    	end
    end

![](https://raw.github.com/xanathar/grimwidgets/master/doc/dialog-custom.png)

### Dialog box with extra widgets

![](https://raw.github.com/xanathar/grimwidgets/master/doc/dialog-widgets.png)

## Low Level (Flexible) Interface
The most common reason to use grimwidgets is to display message popups.

### Available grimwidget elements

- gw_element
- gw_button
- gw_button3D
- gw_rectangle

## Developing your own widgets

TODO
