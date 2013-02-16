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

TODO

![](https://raw.github.com/xanathar/grimwidgets/master/doc/dialog-widgets.png)

### Generic book
Grimwidgets provides a convenient way to define a generic purpose book. It
may be used as a diary, spellbook, questlog, bestiary, or anything else
used to keep information.

First step is to create a book:

    book gw_book.create(id)
    
This call will create and return a book object that will use specified id. Make
sure that your id is unique. The next step is to specify book text color. The rest
of this section assumes that there is an object called book that is an instance
of the book created with gw_book.create().

    book.textColor = { red, green, blue, alpha }
    
This specifies color of the text. red, green, blue and alpha all take values from
0 to 255. Alpha 0 means totally transparent and 255 means totally opaque. This
applies to all following additions. 

The next step is to define first page header:

    book:addPageHeader(pageNumber, headerText)
    
After that a text can be added:

    book:addPageText(pageNumber, text)

You can also add images to the book:

    book:addPageImage(pageNumber, pathToImage, width, height)

It is possible to define columns on a page. Just add regular text with a addPageText
call, and then adjust its width:

    local column1 = book:addPageText(1,"Want multiple columns?")
    column1.width = 100
    col1:calculateHeight()
    local column2 = book:addPageText(1,"Here you go")
    column2:setRelativePosition('after_previous')
    column2.width = 200

After the book is created and contains all required content, you should use it
as any other gwElement. See section below caled "How to use gwElement?".

#### Book example
The following code could be used to create an example book:

    local book = gw_book.create('test_book_1')
    book.textColor = {100,100,100,210}

    -- Define page 1 (with 2 sections)
    book:addPageHeader(1,'This is the header of the 1st page.')
    book:addPageText(1, [[This is a multiline
    text about nothing specific.
    Just a text]])
    book:addPageHeader(1,'Second header')
    book:addPageText(1,"There may be many header on the same page")

    -- Define page 2 (with image and multiple columns)
    book.textColor = {200,200,200,210}
    book:addPageHeader(2,'Different font color for this page.')
    book:addPageText(2,'Lets and an image here')
    book:addPageImage(2,'mod_assets/textures/compass_full_E.tga',200,200)
    book:addPageText(2,'and some text below it')

    -- Define multiple columns (still on page 2)
    local col1 = book:addPageText(2,'Want multiple columns?')
    col1.width = 100
    col1:calculateHeight()
    local col2 =book:addPageText(2,'Here you go')
    col2:setRelativePosition('after_previous')
    col2.width = 200
    			
    book:openPagePair(1)
			
    gw.addElement(book)

The following example can produce the following result:
![](https://raw.github.com/xanathar/grimwidgets/master/doc/book.png)

    

## Low Level (Flexible) Interface
The most common reason to use grimwidgets is to display message popups.

### Available grimwidget elements

- gw_element
- gw_button
- gw_button3D
- gw_rectangle

### How to use gwElement?
There are many ways gwElements can be used.

First obvious one is to just diplay it. The following call can be used for that
purpose:

    gw.addElement(gwElement, hookName)

gwElement is a gwElement object, e.g. book. hookName specifies when the gwElement
should be displayed. Currently available hooks are: 'gui' (display always, after GUI
elements are diplayed), 'inventory' (display only when champion inventory is open),
'stats' (display only when statistics are open) or 'skills' (open only when skills
are open). If not specified, the default 'gui' will be assumed.

Once you decide that you no longer wish to see gwElement, you should remove it:

    gw.removeElement(gwElement, hookName)

It is possible to access one widget that is currently being displayed if you know
its id:

    gw.getElement(id, hookName)

It will return gwElement with a specified id (or nil if no such gwElement exists).

## Developing your own widgets
