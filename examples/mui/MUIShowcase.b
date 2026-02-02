{*
** MUIShowcase.b - Comprehensive MUI Widget Demonstration
** ======================================================
**
** This example demonstrates most features of the MUI submod including:
** - Tabbed interface (Register)
** - Full menubar with keyboard shortcuts
** - Text objects and buttons (standard, keyboard, image)
** - String gadgets (text, password, integer)
** - Selection controls (checkmark, cycle, radio)
** - Numeric controls (slider, gauge, numericbutton)
** - Lists with operations
** - Color objects (colorfield, coloradjust, poppen)
** - Popup objects (file, font, poplist)
** - Scrollable content
** - ID-based notifications
** - Hook-based callbacks with SHARED variables
** - Dynamic UI updates
**
** Compile:
**   bas MUIShowcase ace:submods/mui/MUI.o
**
** Copyright (c) 2026 - MUI Submod Example
*}

#include <submods/MUI.h>

{ Libraries (muimaster opened by submod) }
LIBRARY "intuition.library"
LIBRARY "utility.library"

{ ============== Event IDs ============== }
CONST ID_QUIT = -1
CONST ID_ABOUT = 1
CONST ID_NEW = 2
CONST ID_OPEN = 3
CONST ID_SAVE = 4
CONST ID_PREFS = 5
CONST ID_BTN_NORMAL = 10
CONST ID_BTN_KEY = 11
CONST ID_BTN_IMAGE = 12
CONST ID_BTN_APPLY = 13
CONST ID_BTN_RESET = 14
CONST ID_CHK_ENABLE = 20
CONST ID_CYCLE = 21
CONST ID_LIST_ADD = 30
CONST ID_LIST_REM = 31
CONST ID_LIST_CLR = 32
CONST ID_COLOR_COPY = 40
CONST ID_FILE_SELECT = 50
CONST ID_TAB_CHANGE = 60
CONST ID_SHOW_POPUP = 70
CONST ID_CYCLE_CHANGE = 80
CONST ID_RADIO_CHANGE = 81

{ Menu IDs }
CONST ID_MENU_NEW = 100
CONST ID_MENU_OPEN = 101
CONST ID_MENU_SAVE = 102
CONST ID_MENU_ABOUT = 103
CONST ID_MENU_CUT = 110
CONST ID_MENU_COPY = 111
CONST ID_MENU_PASTE = 112
CONST ID_MENU_PREFS = 113
CONST ID_MENU_TOOLBAR = 120
CONST ID_MENU_STATUS = 121
CONST ID_MENU_REFRESH = 122
CONST ID_MENU_DOCS = 130
CONST ID_MENU_ONLINE = 131
CONST ID_MENU_ABOUTMUI = 132

{ Additional MUI constant not in MUI.h }
CONST MUIA_Disabled = &H80423661

{ ============== Global UI Objects ============== }
{ Main }
ADDRESS app, win, mainGroup, menustrip
ADDRESS tabRegister
ADDRESS txtStatus

{ Page 1: Text & Buttons }
ADDRESS txtPlain, txtCentered, txtFramed
ADDRESS btnNormal, btnKey, btnImage
ADDRESS lblButtonClicks

{ Page 2: Input Fields }
ADDRESS strName, strPassword, intAge
ADDRESS txtInputResult, btnApply, btnReset

{ Page 3: Selection }
ADDRESS chkEnable, chkOption1, chkOption2
ADDRESS cycTheme, radSize
ADDRESS txtSelectionResult

{ Page 4: Numeric }
ADDRESS sldVolume, gauProgress, nbValue
ADDRESS txtNumericResult

{ Page 5: Lists }
ADDRESS lstItems, lvItems
ADDRESS strNewItem, btnAddItem, btnRemItem, btnClrItems
ADDRESS txtListResult

{ Page 6: Colors }
ADDRESS clfPreview, cadPicker, popColor
ADDRESS txtColorResult

{ Page 7: Popups }
ADDRESS popFile, popFont, popList
ADDRESS txtPopupResult, btnShowPopup

{ Page 8: Scrolling }
ADDRESS scrollContent, balPane

{ Menu items }
ADDRESS miNew, miOpen, miSave, miAbout, miQuit
ADDRESS miCut, miCopy, miPaste, miPrefs
ADDRESS miCheck1, miCheck2, miRefresh
ADDRESS miDocs, miOnlineHelp, miAboutMUI

{ String arrays (must be global for lifetime) }
DIM cycleEntries&(5)
DIM radioEntries&(5)
DIM poplistEntries&(6)

{ ============== State Variables ============== }
LONGINT buttonClicks
LONGINT running
LONGINT listItemCount
LONGINT currentRed, currentGreen, currentBlue

{ ============== Hook Structures ============== }
DECLARE STRUCT MUIHook hookSlider
DECLARE STRUCT MUIHook hookColorAdj
DECLARE STRUCT MUIHook hookList
DECLARE STRUCT MUIHook hookCycle
DECLARE STRUCT MUIHook hookRadio

{ ==============================================================
  CALLBACK SUBs - Called directly by MUI via hooks
  ============================================================== }

{*
** OnSliderChange - Called when slider value changes
** Demonstrates real-time update of gauge from slider
*}
SUB OnSliderChange(ADDRESS hook, ADDRESS obj, ADDRESS msg) CALLBACK
    SHARED sldVolume, gauProgress, txtNumericResult
    LONGINT sval

    IF sldVolume <> 0& AND gauProgress <> 0& THEN
        sval = MUIGetValue(sldVolume)
        MUISetGauge(gauProgress, sval)
        MUISetText(txtNumericResult, "Slider: " + STR$(sval) + "%")
    END IF

    OnSliderChange = 0&
END SUB

{*
** OnColorChange - Called when coloradjust RGB changes
** Updates the colorfield preview in real-time
*}
SUB OnColorChange(ADDRESS hook, ADDRESS obj, ADDRESS msg) CALLBACK
    SHARED cadPicker, clfPreview, txtColorResult
    SHARED currentRed, currentGreen, currentBlue
    LONGINT r, g, b

    IF cadPicker <> 0& AND clfPreview <> 0& THEN
        r = MUIGetColorRed(cadPicker)
        g = MUIGetColorGreen(cadPicker)
        b = MUIGetColorBlue(cadPicker)

        currentRed = r
        currentGreen = g
        currentBlue = b

        { Colorfield uses different attributes than Coloradjust }
        MUISet(clfPreview, MUIA_Colorfield_Red, r)
        MUISet(clfPreview, MUIA_Colorfield_Green, g)
        MUISet(clfPreview, MUIA_Colorfield_Blue, b)
        MUISetText(txtColorResult, "RGB: " + STR$(r/16777216) + "," + STR$(g/16777216) + "," + STR$(b/16777216))
    END IF

    OnColorChange = 0&
END SUB

{*
** OnListSelect - Called when list selection changes
** Shows selected item in status
*}
SUB OnListSelect(ADDRESS hook, ADDRESS obj, ADDRESS msg) CALLBACK
    SHARED lstItems, txtListResult
    LONGINT idx
    ADDRESS entry

    IF lstItems <> 0& THEN
        idx = MUIListActive(lstItems)
        IF idx >= 0 THEN
            entry = MUIListGetEntry(lstItems, idx)
            IF entry <> 0& THEN
                MUISetText(txtListResult, "Selected: " + CSTR(entry))
            END IF
        ELSE
            MUISetText(txtListResult, "No selection")
        END IF
    END IF

    OnListSelect = 0&
END SUB

{*
** OnCycleChange - Called when cycle selection changes
*}
SUB OnCycleChange(ADDRESS hook, ADDRESS obj, ADDRESS msg) CALLBACK
    SHARED cycTheme, txtSelectionResult, txtStatus
    SHARED cycleEntries&()
    LONGINT idx
    ADDRESS entryPtr

    IF cycTheme <> 0& THEN
        idx = MUIGetActive(cycTheme)
        entryPtr = cycleEntries&(idx)
        IF entryPtr <> 0& THEN
            MUISetText(txtSelectionResult, "Theme: " + CSTR(entryPtr))
            MUISetText(txtStatus, "Theme changed to: " + CSTR(entryPtr))
            PRINT "Theme changed to: "; CSTR(entryPtr)
        END IF
    END IF

    OnCycleChange = 0&
END SUB

{*
** OnRadioChange - Called when radio selection changes
*}
SUB OnRadioChange(ADDRESS hook, ADDRESS obj, ADDRESS msg) CALLBACK
    SHARED radSize, txtSelectionResult, txtStatus
    SHARED radioEntries&()
    LONGINT idx
    ADDRESS entryPtr

    IF radSize <> 0& THEN
        idx = MUIGetRadioActive(radSize)
        entryPtr = radioEntries&(idx)
        IF entryPtr <> 0& THEN
            MUISetText(txtSelectionResult, "Size: " + CSTR(entryPtr))
            MUISetText(txtStatus, "Size changed to: " + CSTR(entryPtr))
            PRINT "Size changed to: "; CSTR(entryPtr)
        END IF
    END IF

    OnRadioChange = 0&
END SUB

{ ============================================================== }
{ Main Program Start }
{ ============================================================== }

{ Temp variables for building UI }
ADDRESS page, grp
ADDRESS grpText, grpButtons, grpResult
ADDRESS grpInputs, grpChecks, grpCycle, grpRadio
ADDRESS grpSlider, grpGauge, grpNumeric
ADDRESS grpList, grpControls
ADDRESS grpPreview, grpPicker
ADDRESS grpPopups
ADDRESS leftPane, rightPane, virtGroup, scrollGroup, content
LONGINT eventID
SHORTINT i
ADDRESS namePtr, pathPtr

{ Initialize state }
buttonClicks = 0
listItemCount = 3
running = -1
currentRed = &H80000000
currentGreen = 0&
currentBlue = &H80000000

PRINT "MUI Widget Showcase"
PRINT "==================="
PRINT

{ Initialize MUI }
MUIInit

IF MUILastError <> MUIERR_NONE THEN
    PRINT "Failed to initialize MUI"
    PRINT "Error: "; MUILastError
    STOP
END IF

PRINT "MUI initialized, version:"; MUIVersion

{ Initialize string arrays for cycle and radio }
cycleEntries&(0) = SADD("Light Theme")
cycleEntries&(1) = SADD("Dark Theme")
cycleEntries&(2) = SADD("System Default")
cycleEntries&(3) = SADD("High Contrast")
cycleEntries&(4) = 0&

radioEntries&(0) = SADD("Small")
radioEntries&(1) = SADD("Medium")
radioEntries&(2) = SADD("Large")
radioEntries&(3) = SADD("Extra Large")
radioEntries&(4) = 0&

poplistEntries&(0) = SADD("Option Alpha")
poplistEntries&(1) = SADD("Option Beta")
poplistEntries&(2) = SADD("Option Gamma")
poplistEntries&(3) = SADD("Option Delta")
poplistEntries&(4) = SADD("Option Epsilon")
poplistEntries&(5) = 0&

{ ============================================================== }
{ Build Menus }
{ ============================================================== }

PRINT "Building menus..."

MUIBeginMenustrip
    MUIBeginMenu("Project")
        miNew = MUIMenuitem("New", "N")
        miOpen = MUIMenuitem("Open...", "O")
        miSave = MUIMenuitem("Save", "S")
        MUIMenuSeparator
        miAbout = MUIMenuitem("About...", "?")
        MUIMenuSeparator
        miQuit = MUIMenuitem("Quit", "Q")
    MUIEndMenu
    MUIBeginMenu("Edit")
        miCut = MUIMenuitem("Cut", "X")
        miCopy = MUIMenuitem("Copy", "C")
        miPaste = MUIMenuitem("Paste", "V")
        MUIMenuSeparator
        miPrefs = MUIMenuitem("Preferences...", "P")
    MUIEndMenu
    MUIBeginMenu("View")
        miCheck1 = MUIMenuitemCheck("Show Toolbar", "T", -1)
        miCheck2 = MUIMenuitemCheck("Show Status", "B", -1)
        MUIMenuSeparator
        miRefresh = MUIMenuitemNoKey("Refresh")
    MUIEndMenu
    MUIBeginMenu("Help")
        miDocs = MUIMenuitemNoKey("Documentation")
        miOnlineHelp = MUIMenuitemNoKey("Online Help")
        MUIMenuSeparator
        miAboutMUI = MUIMenuitemNoKey("About MUI...")
    MUIEndMenu
menustrip = MUIEndMenustrip

IF menustrip = 0& THEN PRINT "Failed to create menustrip" : GOTO cleanup

{ ============================================================== }
{ Build Page 1: Text & Buttons }
{ ============================================================== }

PRINT "Building Page 1: Text & Buttons..."

txtPlain = MUIText("Plain text - left aligned")
txtCentered = MUITextCentered("Centered text")
txtFramed = MUITextFramed("Framed text with border")

MUIBeginVGroup
    MUIGroupFrameT("Text Objects")
    MUIChild(txtPlain)
    MUIChild(txtCentered)
    MUIChild(txtFramed)
grpText = MUIEndGroup

btnNormal = MUIButton("Normal Button")
btnKey = MUIKeyButton("_Keyboard (Alt+K)", "k")
btnImage = MUIImageButton(MUII_PopFile)

MUIBeginVGroup
    MUIGroupFrameT("Button Types")
    MUIChild(btnNormal)
    MUIChild(btnKey)
    MUIBeginHGroup
        MUIChild(MUILabelRight("Image button:"))
        MUIChild(btnImage)
        MUIChild(MUIRectangle)
    MUIChild(MUIEndGroup)
grpButtons = MUIEndGroup

lblButtonClicks = MUIText("Button clicks: 0")

MUIBeginVGroup
    MUIGroupFrameT("Interaction")
    MUIChild(lblButtonClicks)
    MUIChild(MUIText("Click any button above to see events"))
grpResult = MUIEndGroup

MUIBeginVGroup
    MUIChild(grpText)
    MUIChild(grpButtons)
    MUIChild(grpResult)
page = MUIEndGroup

MUIBeginRegister("Buttons|Input|Selection|Numeric|Lists|Colors|Popups|Scrolling")
MUIRegisterPage(page)

{ ============================================================== }
{ Build Page 2: Input Fields }
{ ============================================================== }

PRINT "Building Page 2: Input Fields..."

strName = MUIString("", 40)
strPassword = MUIStringSecret("", 20)
intAge = MUIInteger(25)
txtInputResult = MUIText("Enter values above and click Apply")
btnApply = MUIButton("Apply")
btnReset = MUIButton("Reset")

MUIBeginColGroup(2)
    MUIGroupFrameT("Input Fields")
    MUIChild(MUILabelRight("Name:"))
    MUIChild(strName)
    MUIChild(MUILabelRight("Password:"))
    MUIChild(strPassword)
    MUIChild(MUILabelRight("Age:"))
    MUIChild(intAge)
grpInputs = MUIEndGroup

MUIBeginVGroup
    MUIChild(grpInputs)
    MUIChild(MUIHBar)
    MUIChild(txtInputResult)
    MUIBeginHGroup
        MUIGroupSameSize
        MUIChild(btnApply)
        MUIChild(btnReset)
    MUIChild(MUIEndGroup)
page = MUIEndGroup

MUIRegisterPage(page)

{ ============================================================== }
{ Build Page 3: Selection Controls }
{ ============================================================== }

PRINT "Building Page 3: Selection Controls..."

chkEnable = MUIKeyCheckmark(-1, "e")
chkOption1 = MUICheckmark(0)
chkOption2 = MUICheckmark(-1)

MUIBeginColGroup(2)
    MUIGroupFrameT("Checkmarks")
    MUIChild(MUILabelRight("Enable features:"))
    MUIChild(chkEnable)
    MUIChild(MUILabelRight("Option 1:"))
    MUIChild(chkOption1)
    MUIChild(MUILabelRight("Option 2:"))
    MUIChild(chkOption2)
grpChecks = MUIEndGroup

cycTheme = MUICycle(VARPTR(cycleEntries&(0)))

MUIBeginColGroup(2)
    MUIGroupFrameT("Cycle Gadget")
    MUIChild(MUILabelRight("Theme:"))
    MUIChild(cycTheme)
grpCycle = MUIEndGroup

radSize = MUIRadio(VARPTR(radioEntries&(0)))

MUIBeginVGroup
    MUIGroupFrameT("Radio Buttons")
    MUIChild(radSize)
grpRadio = MUIEndGroup

txtSelectionResult = MUIText("Make selections to see changes")

MUIBeginVGroup
    MUIBeginHGroup
        MUIChild(grpChecks)
        MUIChild(grpCycle)
    MUIChild(MUIEndGroup)
    MUIChild(grpRadio)
    MUIChild(MUIHBar)
    MUIChild(txtSelectionResult)
page = MUIEndGroup

MUIRegisterPage(page)

{ ============================================================== }
{ Build Page 4: Numeric Controls }
{ ============================================================== }

PRINT "Building Page 4: Numeric Controls..."

sldVolume = MUISlider(0, 100, 50)
gauProgress = MUIGauge(100)
MUISetGauge(gauProgress, 50)

MUIBeginColGroup(2)
    MUIGroupFrameT("Slider with Gauge")
    MUIChild(MUILabelRight("Volume:"))
    MUIChild(sldVolume)
    MUIChild(MUILabelRight("Level:"))
    MUIChild(gauProgress)
grpSlider = MUIEndGroup

nbValue = MUINumericbutton(0, 255, 128)

MUIBeginColGroup(2)
    MUIGroupFrameT("Numeric Button")
    MUIChild(MUILabelRight("Value (0-255):"))
    MUIChild(nbValue)
grpNumeric = MUIEndGroup

txtNumericResult = MUIText("Slider: 50%")

MUIBeginVGroup
    MUIChild(grpSlider)
    MUIChild(grpNumeric)
    MUIChild(MUIHBar)
    MUIChild(txtNumericResult)
page = MUIEndGroup

MUIRegisterPage(page)

{ ============================================================== }
{ Build Page 5: Lists }
{ ============================================================== }

PRINT "Building Page 5: Lists..."

lstItems = MUIList
lvItems = MUIListview(lstItems)

MUIListInsert(lstItems, "First Item")
MUIListInsert(lstItems, "Second Item")
MUIListInsert(lstItems, "Third Item")

strNewItem = MUIString("New item", 40)
btnAddItem = MUIButton("Add")
btnRemItem = MUIButton("Remove")
btnClrItems = MUIButton("Clear All")

MUIBeginVGroup
    MUIGroupFrameT("List Operations")
    MUIChild(lvItems)
    MUIBeginHGroup
        MUIChild(strNewItem)
        MUIChild(btnAddItem)
    MUIChild(MUIEndGroup)
    MUIBeginHGroup
        MUIGroupSameSize
        MUIChild(btnRemItem)
        MUIChild(btnClrItems)
    MUIChild(MUIEndGroup)
grpList = MUIEndGroup

txtListResult = MUIText("Select an item or modify the list")

MUIBeginVGroup
    MUIChild(grpList)
    MUIChild(MUIHBar)
    MUIChild(txtListResult)
page = MUIEndGroup

MUIRegisterPage(page)

{ ============================================================== }
{ Build Page 6: Colors }
{ ============================================================== }

PRINT "Building Page 6: Colors..."

clfPreview = MUIColorfield(&H80000000, &H00000000, &H80000000)

MUIBeginVGroup
    MUIGroupFrameT("Color Preview")
    MUIChild(clfPreview)
grpPreview = MUIEndGroup

cadPicker = MUIColoradjustRGB(&H80000000, &H00000000, &H80000000)
popColor = MUIPoppen

MUIBeginVGroup
    MUIGroupFrameT("Color Picker")
    MUIChild(cadPicker)
    MUIBeginHGroup
        MUIChild(MUILabelRight("Quick pick:"))
        MUIChild(popColor)
        MUIChild(MUIRectangle)
    MUIChild(MUIEndGroup)
grpPicker = MUIEndGroup

txtColorResult = MUIText("Adjust colors using the sliders")

MUIBeginVGroup
    MUIBeginHGroup
        MUIChildWeight(grpPreview, 30)
        MUIChildWeight(grpPicker, 70)
    MUIChild(MUIEndGroup)
    MUIChild(MUIHBar)
    MUIChild(txtColorResult)
page = MUIEndGroup

MUIRegisterPage(page)

{ ============================================================== }
{ Build Page 7: Popups }
{ ============================================================== }

PRINT "Building Page 7: Popups..."

popFile = MUIPopaslFile("Select File", "#?")
popFont = MUIPopaslFont("Select Font")
popList = MUIPoplist(VARPTR(poplistEntries&(0)))
btnShowPopup = MUIButton("Show Values")

MUIBeginColGroup(2)
    MUIGroupFrameT("Popup Objects")
    MUIChild(MUILabelRight("File:"))
    MUIChild(popFile)
    MUIChild(MUILabelRight("Font:"))
    MUIChild(popFont)
    MUIChild(MUILabelRight("Option:"))
    MUIChild(popList)
grpPopups = MUIEndGroup

txtPopupResult = MUIText("Click popup buttons to make selections")

MUIBeginVGroup
    MUIChild(grpPopups)
    MUIChild(btnShowPopup)
    MUIChild(MUIHBar)
    MUIChild(txtPopupResult)
page = MUIEndGroup

MUIRegisterPage(page)

{ ============================================================== }
{ Build Page 8: Scrolling & Balance }
{ ============================================================== }

PRINT "Building Page 8: Scrolling & Balance..."

MUIBeginVGroup
    MUIGroupFrameT("Left Pane")
    MUIChild(MUIText("Drag the balance"))
    MUIChild(MUIText("bar to resize panes"))
    MUIChild(MUIHBar)
    MUIChild(MUIButton("Button 1"))
    MUIChild(MUIButton("Button 2"))
leftPane = MUIEndGroup

MUIBeginVGroup
    FOR i = 1 TO 15
        MUIChild(MUIText("Scrollable line " + STR$(i)))
    NEXT i
content = MUIEndGroup

virtGroup = MUIVirtgroup(content)
scrollGroup = MUIScrollgroupVert(virtGroup)

MUIBeginVGroup
    MUIGroupFrameT("Scrollable Content")
    MUIChild(scrollGroup)
rightPane = MUIEndGroup

balPane = MUIBalance

MUIBeginHGroup
    MUIChildWeight(leftPane, 40)
    MUIChild(balPane)
    MUIChildWeight(rightPane, 60)
page = MUIEndGroup

MUIRegisterPage(page)

{ Finish the register }
tabRegister = MUIEndRegister

IF tabRegister = 0& THEN PRINT "Failed to create register" : GOTO cleanup

{ ============================================================== }
{ Build Main Layout }
{ ============================================================== }

PRINT "Building main layout..."

txtStatus = MUITextFramed("Welcome to MUI Showcase - interact with the widgets!")

MUIBeginVGroup
    MUIChild(tabRegister)
    MUIChild(txtStatus)
mainGroup = MUIEndGroup

IF mainGroup = 0& THEN PRINT "Failed to create main group" : GOTO cleanup

{ Create window with menu }
win = MUIWindowWithMenu("MUI Widget Showcase", mainGroup, menustrip)

IF win = 0& THEN
    PRINT "Failed to create window"
    GOTO cleanup
END IF

{ Create application }
app = MUIApp("MUIShowcase", "$VER: MUIShowcase 1.0 (2026)", win)

IF app = 0& THEN
    PRINT "Failed to create application"
    GOTO cleanup
END IF

PRINT "Application created"

{ ============================================================== }
{ Setup Notifications }
{ ============================================================== }

PRINT "Setting up notifications..."

{ Window close }
MUINotifyClose(win, app, ID_QUIT)

{ Menu notifications }
MUINotifyMenu(miNew, app, ID_MENU_NEW)
MUINotifyMenu(miOpen, app, ID_MENU_OPEN)
MUINotifyMenu(miSave, app, ID_MENU_SAVE)
MUINotifyMenu(miAbout, app, ID_MENU_ABOUT)
MUINotifyMenu(miQuit, app, ID_QUIT)
MUINotifyMenu(miCut, app, ID_MENU_CUT)
MUINotifyMenu(miCopy, app, ID_MENU_COPY)
MUINotifyMenu(miPaste, app, ID_MENU_PASTE)
MUINotifyMenu(miPrefs, app, ID_MENU_PREFS)
MUINotifyMenu(miCheck1, app, ID_MENU_TOOLBAR)
MUINotifyMenu(miCheck2, app, ID_MENU_STATUS)
MUINotifyMenu(miRefresh, app, ID_MENU_REFRESH)
MUINotifyMenu(miDocs, app, ID_MENU_DOCS)
MUINotifyMenu(miOnlineHelp, app, ID_MENU_ONLINE)
MUINotifyMenu(miAboutMUI, app, ID_MENU_ABOUTMUI)

{ Button notifications (ID-based) }
MUINotifyButton(btnNormal, app, ID_BTN_NORMAL)
MUINotifyButton(btnKey, app, ID_BTN_KEY)
MUINotifyButton(btnImage, app, ID_BTN_IMAGE)
MUINotifyButton(btnApply, app, ID_BTN_APPLY)
MUINotifyButton(btnReset, app, ID_BTN_RESET)

{ Selection notifications }
MUINotifyCheckmark(chkEnable, app, ID_CHK_ENABLE)

{ List button notifications }
MUINotifyButton(btnAddItem, app, ID_LIST_ADD)
MUINotifyButton(btnRemItem, app, ID_LIST_REM)
MUINotifyButton(btnClrItems, app, ID_LIST_CLR)

{ Popup show button }
MUINotifyButton(btnShowPopup, app, ID_SHOW_POPUP)

{ Hook-based notifications for real-time updates }

{ Slider -> Gauge (live update) }
MUISetupHookA4(hookSlider, @OnSliderChange, 0&)
MUINotifyAttrHook(sldVolume, MUIA_Numeric_Value, hookSlider)

{ Coloradjust -> Colorfield (live update) }
MUISetupHookA4(hookColorAdj, @OnColorChange, 0&)
MUINotifyAttrHook(cadPicker, MUIA_Coloradjust_Red, hookColorAdj)
MUINotifyAttrHook(cadPicker, MUIA_Coloradjust_Green, hookColorAdj)
MUINotifyAttrHook(cadPicker, MUIA_Coloradjust_Blue, hookColorAdj)

{ List selection (live update) }
MUISetupHookA4(hookList, @OnListSelect, 0&)
MUINotifyAttrHook(lstItems, MUIA_List_Active, hookList)

{ Cycle gadget (live update) }
MUISetupHookA4(hookCycle, @OnCycleChange, 0&)
MUINotifyAttrHook(cycTheme, MUIA_Cycle_Active, hookCycle)

{ Radio buttons (live update) }
MUISetupHookA4(hookRadio, @OnRadioChange, 0&)
MUINotifyAttrHook(radSize, MUIA_Radio_Active, hookRadio)

PRINT "Notifications set up"

{ ============================================================== }
{ Open Window and Event Loop }
{ ============================================================== }

MUIWindowOpen(win)

PRINT "Window opened"
PRINT
PRINT "Interact with the widgets to see events."
PRINT "Close the window or select Quit to exit."
PRINT

WHILE running
    eventID = MUIWaitEvent(app)

    IF eventID = ID_QUIT THEN
        PRINT "Quit requested"
        running = 0
    END IF

    IF eventID = MUIV_Application_ReturnID_Quit THEN
        PRINT "Window close requested"
        running = 0
    END IF

    IF eventID = ID_BTN_NORMAL THEN
        buttonClicks = buttonClicks + 1
        MUISetText(lblButtonClicks, "Button clicks: " + STR$(buttonClicks))
        MUISetText(txtStatus, "Normal button clicked")
        PRINT "Normal button clicked"
    END IF

    IF eventID = ID_BTN_KEY THEN
        buttonClicks = buttonClicks + 1
        MUISetText(lblButtonClicks, "Button clicks: " + STR$(buttonClicks))
        MUISetText(txtStatus, "Keyboard button clicked (Alt+K)")
        PRINT "Keyboard button clicked"
    END IF

    IF eventID = ID_BTN_IMAGE THEN
        buttonClicks = buttonClicks + 1
        MUISetText(lblButtonClicks, "Button clicks: " + STR$(buttonClicks))
        MUISetText(txtStatus, "Image button clicked")
        PRINT "Image button clicked"
    END IF

    IF eventID = ID_BTN_APPLY THEN
        namePtr = MUIGetStringContents(strName)
        IF namePtr <> 0& THEN
            MUISetText(txtInputResult, "Name: " + CSTR(namePtr) + ", Age: " + STR$(MUIGetInteger(intAge)))
            MUISetText(txtStatus, "Apply clicked - values displayed")
            PRINT "Apply: Name="; CSTR(namePtr); " Age="; MUIGetInteger(intAge)
        ELSE
            MUISetText(txtInputResult, "Age: " + STR$(MUIGetInteger(intAge)))
        END IF
    END IF

    IF eventID = ID_BTN_RESET THEN
        MUISetStringContents(strName, "")
        MUISetStringContents(strPassword, "")
        MUISet(intAge, MUIA_String_Integer, 25)
        MUISetText(txtInputResult, "Fields reset to defaults")
        MUISetText(txtStatus, "Input fields reset")
        PRINT "Fields reset"
    END IF

    IF eventID = ID_CHK_ENABLE THEN
        IF MUIGetChecked(chkEnable) THEN
            MUISet(chkOption1, MUIA_Disabled, 0&)
            MUISet(chkOption2, MUIA_Disabled, 0&)
            MUISetText(txtSelectionResult, "Features enabled")
            MUISetText(txtStatus, "Features enabled")
            PRINT "Features enabled"
        ELSE
            MUISet(chkOption1, MUIA_Disabled, -1&)
            MUISet(chkOption2, MUIA_Disabled, -1&)
            MUISetText(txtSelectionResult, "Features disabled")
            MUISetText(txtStatus, "Features disabled")
            PRINT "Features disabled"
        END IF
    END IF

    IF eventID = ID_LIST_ADD THEN
        namePtr = MUIGetStringContents(strNewItem)
        IF namePtr <> 0& THEN
            IF LEN(CSTR(namePtr)) > 0 THEN
                MUIListInsert(lstItems, CSTR(namePtr))
                MUISetText(txtListResult, "Added: " + CSTR(namePtr))
                MUISetStringContents(strNewItem, "")
                MUISetText(txtStatus, "Item added to list")
                PRINT "Added item: "; CSTR(namePtr)
            END IF
        END IF
    END IF

    IF eventID = ID_LIST_REM THEN
        IF MUIListActive(lstItems) >= 0 THEN
            MUIListRemove(lstItems, MUIListActive(lstItems))
            MUISetText(txtListResult, "Item removed")
            MUISetText(txtStatus, "Item removed from list")
            PRINT "Item removed"
        ELSE
            MUISetText(txtListResult, "Select an item first")
        END IF
    END IF

    IF eventID = ID_LIST_CLR THEN
        MUIListClear(lstItems)
        MUISetText(txtListResult, "List cleared")
        MUISetText(txtStatus, "List cleared")
        PRINT "List cleared"
    END IF

    IF eventID = ID_SHOW_POPUP THEN
        pathPtr = MUIPopstringValue(popFile)
        IF pathPtr <> 0& THEN
            MUISetText(txtPopupResult, "File: " + CSTR(pathPtr))
            MUISetText(txtStatus, "Popup values shown")
            PRINT "File: "; CSTR(pathPtr)
        ELSE
            MUISetText(txtPopupResult, "No file selected")
        END IF
    END IF

    { Menu event handling }
    IF eventID = ID_MENU_NEW THEN
        MUISetText(txtStatus, "Menu: New - would create new document")
        PRINT "Menu: New"
    END IF

    IF eventID = ID_MENU_OPEN THEN
        MUISetText(txtStatus, "Menu: Open - would show file requester")
        PRINT "Menu: Open"
    END IF

    IF eventID = ID_MENU_SAVE THEN
        MUISetText(txtStatus, "Menu: Save - would save document")
        PRINT "Menu: Save"
    END IF

    IF eventID = ID_MENU_ABOUT THEN
        MUISetText(txtStatus, "MUI Showcase - demonstrates MUI submod features")
        PRINT "Menu: About"
    END IF

    IF eventID = ID_MENU_CUT THEN
        MUISetText(txtStatus, "Menu: Cut - would cut selection")
        PRINT "Menu: Cut"
    END IF

    IF eventID = ID_MENU_COPY THEN
        MUISetText(txtStatus, "Menu: Copy - would copy selection")
        PRINT "Menu: Copy"
    END IF

    IF eventID = ID_MENU_PASTE THEN
        MUISetText(txtStatus, "Menu: Paste - would paste clipboard")
        PRINT "Menu: Paste"
    END IF

    IF eventID = ID_MENU_PREFS THEN
        MUISetText(txtStatus, "Menu: Preferences - would open settings")
        PRINT "Menu: Preferences"
    END IF

    IF eventID = ID_MENU_TOOLBAR THEN
        IF MUIMenuGetChecked(miCheck1) THEN
            MUISetText(txtStatus, "Menu: Toolbar is now visible")
            PRINT "Menu: Show Toolbar"
        ELSE
            MUISetText(txtStatus, "Menu: Toolbar is now hidden")
            PRINT "Menu: Hide Toolbar"
        END IF
    END IF

    IF eventID = ID_MENU_STATUS THEN
        IF MUIMenuGetChecked(miCheck2) THEN
            MUISetText(txtStatus, "Menu: Status bar is now visible")
            PRINT "Menu: Show Status"
        ELSE
            MUISetText(txtStatus, "Menu: Status bar is now hidden")
            PRINT "Menu: Hide Status"
        END IF
    END IF

    IF eventID = ID_MENU_REFRESH THEN
        MUISetText(txtStatus, "Menu: Refresh - would refresh view")
        PRINT "Menu: Refresh"
    END IF

    IF eventID = ID_MENU_DOCS THEN
        MUISetText(txtStatus, "Menu: Documentation - see docs/MUI-Submod.txt")
        PRINT "Menu: Documentation"
    END IF

    IF eventID = ID_MENU_ONLINE THEN
        MUISetText(txtStatus, "Menu: Online Help - would open browser")
        PRINT "Menu: Online Help"
    END IF

    IF eventID = ID_MENU_ABOUTMUI THEN
        MUISetText(txtStatus, "Menu: About MUI - Magic User Interface by Stefan Stuntz")
        PRINT "Menu: About MUI"
    END IF

WEND

{ ============================================================== }
{ Cleanup }
{ ============================================================== }

PRINT "Cleaning up..."

cleanup:

IF app <> 0& THEN
    MUIDispose(app)
END IF

MUICleanup

LIBRARY CLOSE "utility.library"
LIBRARY CLOSE "intuition.library"

PRINT "Done!"
END
