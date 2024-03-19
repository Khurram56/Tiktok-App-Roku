sub init()
        m.poster = m.top.findNode("poster")
        m.qrcode = m.top.findNode("qrcode")
        m.qrcode_bg = m.top.findNode("qrcode_bg")
        m.RateUstitle = m.top.findNode("RateUstitle")
        m.Feedbacktitle = m.top.findNode("Feedbacktitle")
        m.categoriestitle = m.top.findNode("categoriestitle")
        m.Categories = m.top.findNode("Categories")

        m.Rate_us = m.top.findNode("Rate_us")
        m.feedback = m.top.findNode("feedback")
        m.Categories_btn = m.top.findNode("Categories_btn")
        m.rateUsdescription = m.top.findNode("rateUsdescription")
        m.stars = m.top.findNode("stars")

        m.Rate_us.observeField("buttonSelected", "rateUs")
        m.feedback.observeField("buttonSelected", "feedBackScreen")
        m.Categories.observeField("buttonSelected", "CategoriesScreen")
        m.Categories_btn.observeField("buttonSelected", "onCategories_btnSelected")

        checkListContent = createObject("RoSGNode", "ContentNode")
        jsonFile = RegRead("defaltPreferences")
        checkListItems = parseJson(jsonFile)
        for each item in checkListItems
            checkListItem = checkListContent.CreateChild("ContentNode")
            checkListItem.title = item["title"]
        end for
        m.exampleCheckList = m.top.findNode("exampleCheckList")
        m.exampleCheckList.observeField("itemSelected", "onChecklistItemChecked")
        'm.exampleCheckList.checkedState = [ true, true, true, true,false, false, false, false,false, false, false, false,false, false ]
        m.exampleCheckList.content = checkListContent
        m.exampleCheckList.visible=false

        m.qrcode.visible=false
        m.qrcode_bg.visible=false
        m.Categories_btn.visible=false
end sub

sub onChecklistItemChecked(event as Object)
        ' sec = CreateObject("roRegistrySection", "MY_SECTION")
        ' sec.Write(m.a)
        ' sec.Flush()
        'RegWrite("MY_SECTION", m.a)
        m.a = RegRead("MY_SECTION")
            if m.a <> invalid
                print "valid "
                m.a = m.a.toInt()
            else
                print "Registry value not found or is invalid"
                m.a = 0
            end if
            

        if m.a < 6
                print"reg valuee "m.a
                jsonFile = RegRead("defaltPreferences")
                jsonObj = ParseJson(jsonFile)

                selectedId = m.exampleCheckList.itemSelected
                item = jsonObj[selectedId]
                if selectedId <> invalid and item.checked=false 
                        item.checked = true
                        checkedStates = m.exampleCheckList.checkedState[selectedId]=true
                        m.a = m.a + 1
                        RegWrite("MY_SECTION", str(m.a))
                else if item.checked=true 
                        item.checked = false
                        m.a = m.a - 1
                        print " reg vsalue"m.a
                        RegWrite("MY_SECTION", str(m.a))
                end if
                
                jsonString = FormatJson(jsonObj)
                RegWrite("defaltPreferences", jsonString)
                print "new :::"RegRead("defaltPreferences")
        else
                checklistLimitDialog()
                print "limit reached"
                print"reg valuee "m.a
                jsonFile = RegRead("defaltPreferences")
                jsonObj = ParseJson(jsonFile)

                selectedId = m.exampleCheckList.itemSelected
                item = jsonObj[selectedId]
                if selectedId <> invalid and item.checked=true 
                        item.checked = false
                        m.a = m.a - 1
                        print " reg vsalue"m.a
                        RegWrite("MY_SECTION", str(m.a))
                end if
                
                jsonString = FormatJson(jsonObj)
                RegWrite("defaltPreferences", jsonString)
                'print "new :::"RegRead("defaltPreferences")
end if
end sub

sub rateUs()
        print "key pressed"
        m.videoFetchingTask = CreateObject("roSGNode", "RateUsTask")
        m.videoFetchingTask.control = "run"
end sub

sub feedBackScreen()
        m.rateUsdescription.visible=false
        m.stars.visible=false
        m.RateUstitle.visible=false
        m.exampleCheckList.visible=false

        m.categoriestitle.visible=false
        m.Categories_btn.visible=false

        m.qrcode.visible=true
        m.qrcode_bg.visible=true
        m.Feedbacktitle.visible=true
end sub

sub CategoriesScreen()
        CheckSubscriptionAndStartPlayback()
end sub

sub CategoriesScreenData()
        m.rateUsdescription.visible=false
        m.stars.visible=false
        m.RateUstitle.visible=false

        m.qrcode.visible=false
        m.qrcode_bg.visible=false
        m.Feedbacktitle.visible=false

        m.categoriestitle.visible=true
        m.Categories_btn.visible=true
        m.exampleCheckList.visible=true
        'states = RegRead("defaltPreferences")
        m.exampleCheckList.checkedState = getCheckedStateFromRegistry()
end sub
function getCheckedStateFromRegistry()
        checkedState = []
        favourites = RegRead("defaltPreferences")
        if favourites <> invalid then
                favourites = ParseJson(favourites)
                for each favourite in favourites
                        checkedState.push(favourite.checked)
                end for
        end if
        return checkedState
end function

sub subcriptionCheckDialog()
        dialog = createObject("roSGNode", "StandardMessageDialog")
        dialog.title = "Subscription Required"
        dialog.message = ["You are not a subscribed user, Buy Subscription first!"]
        dialog.buttons = ["Buy Now","Ok"]
        dialog.observeFieldScoped("buttonSelected", "DailyLimtDialogButtonSelected")
        m.greenPalette = createObject("roSGNode", "RSGPalette")
        m.greenPalette.colors = {DialogBackgroundColor: "0x3d3c3c",
                                DialogFocusColor: "0xFF004F",
                                DialogFocusItemColor: "0xddddddff",
                                DialogFootprintColor: "0xddddddff" }
        m.top.getScene().palette = m.greenPalette
        m.top.getScene().dialog = dialog
end sub

sub DailyLimtDialogButtonSelected(event as object)
        button1 = event.getData()
        if m.top.getScene().dialog <> invalid
                m.top.getScene().dialog.close = true
        end if
        if button1 = 0
                m.top.ctg_ButtonSelected = "abc"
                'm.top.getScene().dialog.close = true
                'button1.observeField("buttonSelected", "onCtgButtonSelected")
        end if
        if button1 = 1
                m.top.getScene().dialog.close = true
        end if
end sub

sub onCtgButtonSelected()
        print "ctg button pressed!"
end sub

sub checklistLimitDialog()
        dialog = createObject("roSGNode", "StandardMessageDialog")
        dialog.title = "Limit Reached"
        dialog.message = ["You have reached the limit, uncheck categories first!"]
        dialog.buttons = ["Cancel"]
        dialog.observeFieldScoped("buttonSelected", "DailyLimtDialogButtonSelected")
        m.greenPalette = createObject("roSGNode", "RSGPalette")
        m.greenPalette.colors = {DialogBackgroundColor: "0x3d3c3c",
                                DialogFocusColor: "0xFF004F",
                                DialogFocusItemColor: "0xddddddff",
                                DialogFootprintColor: "0xddddddff" }
        m.top.getScene().palette = m.greenPalette
        m.top.getScene().dialog = dialog
end sub

sub DailyLimtDialogButtonSelected1(event as object)
        button = event.getData()
        if m.top.getScene().dialog <> invalid
        m.top.getScene().dialog.close = true
        end if
        if button = 0
        m.top.getScene().dialog.close = true
        end if
end sub

sub onCategories_btnSelected(event as object)
        print "categories button pressed"
        m.index =m.exampleCheckList.itemSelected
        print "item id : "m.exampleCheckList.itemSelected


        ' jsonFile = RegRead("defaltPreferences")
        ' jsonObj = ParseJson(jsonFile)

        if m.exampleCheckList.itemSelected >= 0 
        '         selectedId = m.exampleCheckList.itemSelected
        ' for i = 0 to 14
        '         item = jsonObj[selectedId]
        ' if selectedId <> invalid and item.checked=false
        '         item.checked = true
        '         checkedStates = m.exampleCheckList.checkedState[selectedId]=true
        ' else if item.checked=true 
        '         item.checked = false
        ' end if
        ' end for
        ' jsonString = FormatJson(jsonObj)
        ' RegWrite("defaltPreferences", jsonString)
        ' print "new :::"RegRead("defaltPreferences")
        else
        print " select"
        end if
end sub

function RegRead(key, section = invalid)
        if section = invalid section = "Default"
        sec = CreateObject("roRegistrySection", section)
        if sec.Exists(key)
                return sec.Read(key)
        else
                m.itemExists = false
                return invalid
        end if
        return invalid
end function

function RegWrite(key, val, section = invalid)
        'print  "Here in reg write"
        if section = invalid section = "Default"
        m.sec = CreateObject("roRegistrySection", section)
        m.sec.Write(key, val)
        m.sec.Flush() 'commit it
        'print  "Wrote " val " to " key
end function

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false
    if press
        if key = "left" and m.Rate_us.hasFocus()
                m.Categories.setFocus(true)
        else if key = "down"
                m.Categories.setFocus(true)
        else if key = "right" and m.Categories.hasFocus()
                m.Rate_us.setFocus(true)
        else if key = "up" and m.Categories.hasFocus()
                m.Categories_btn.setFocus(true)
        else if key = "up" and m.Rate_us.hasFocus()
                m.Categories_btn.setFocus(true)
        else if key = "up" and m.feedback.hasFocus()
                m.Categories_btn.setFocus(true)
        else if key = "up" and m.Categories_btn.hasFocus()
                m.exampleCheckList.setFocus(true)
        else if key = "down" and m.exampleCheckList.hasFocus()
                m.Categories_btn.setFocus(true)
        else if key = "down" and m.Categories_btn.hasFocus()
                m.Categories.setFocus(true)
        else if key = "right" and m.Rate_us.hasFocus()
                m.feedback.setFocus(true)
        else if key = "left" and m.feedback.hasFocus()
                m.Rate_us.setFocus(true)
        end if
    end if
    return handled
end function