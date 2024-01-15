sub init()
    'print  "Called init"
    'print  "Called regwrite"

    m.preferencesArr = []
    m.preferencestext = ""
    m.writeText = ""
    m.i = 0
    m.query = "Trending"
    m.checkOnItemClicked = false
    m.checkOnAddButtonClicked = false

    m.searchQuery = m.top.findNode("searchQuery")
    m.butonUp = m.top.findNode("butonUp")
    m.option = m.top.findNode("option")
    m.butonDown = m.top.findNode("butonDown")
    m.searchQuery.visible = false
    m.rowList = m.top.findNode("rowList")
    m.rowList.setFocus(true)
    m.video = m.top.findNode("musicvideos")
    m.top.ObserveField("visible", "OnVisibleChange")
    m.rowList.ObserveField("rowItemSelected", "OnItemClicked")
    m.butonUp.observeField("buttonSelected", "moveVideoUp")
    m.butonDown.observeField("buttonSelected", "moveVideoDown")
    m.option.observeField("buttonSelected", "OptionButtonClicked")

    getCategoriesTask()
    apiRequestSpinner()
    videosRendered()
    getBusySpinner()
end sub

sub AddPreferencesButtonClicked()

    if (m.video.control = "play") or (m.video.control = "resume")
        m.video.control = "pause"
    end if
    m.checkOnAddButtonClicked = true 'when add preferences button press set true
    CheckSubscriptionAndStartPlayback()
end sub

''Loading Spinner
sub getBusySpinner()
    m.busyspinner = m.top.findNode("busySpinner")
    m.busyspinner.poster.observeField("loadStatus", "showspinner")
    m.busyspinner.poster.uri = "pkg:/images/flickr.png"
    'm.busyspinner.control = "start"
end sub
sub showspinner()
    m.checkSpinner = "empty"
    if(m.busyspinner.poster.loadStatus = "ready")
        centerx = (1280 - m.busyspinner.poster.bitmapWidth) / 2
        centery = (720 - m.busyspinner.poster.bitmapWidth) / 2
        m.busyspinner.translation = [centerx, centery]
        m.busyspinner.visible = true
        m.checkSpinner = "loaded"
    end if
end sub

sub OptionButtonClicked()
    if m.video.control = "play" or m.video.control = "resume"
        m.video.control = "pause"
    end if
end sub

sub apiRequestSpinner()
    m.exampleBusyspinner = m.top.findNode("exampleBusySpinner")
    m.exampleBusyspinner.poster.observeField("loadStatus", "showSearchSpinner")
    m.exampleBusyspinner.poster.uri = "pkg:/images/busyspinner_hd.png"
    'm.busyspinner.control = "start"
end sub
sub showSearchSpinner()
    m.checkBusySpinner = "empty"
    if(m.exampleBusyspinner.poster.loadStatus = "ready")
        centerx = (1280 - m.exampleBusyspinner.poster.bitmapWidth) / 2
        centery = (720 - m.exampleBusyspinner.poster.bitmapWidth) / 2
        m.exampleBusyspinner.translation = [centerx, centery]
        m.exampleBusyspinner.visible = false
        m.checkBusySpinner = "loaded"
    end if
end sub

function fetchVideos()
    m.videoFetchingTask = CreateObject("roSGNode", "GetVideos")
    m.videoFetchingTask.changes = "false"
    m.videoFetchingTask.preferences = m.query
    m.searchQuery.text = m.query
    print "Query...." m.query
    m.videoFetchingTask.ObserveField("videosArr", "videosRendered")
    m.videoFetchingTask.ObserveField("error", "GettingError")
    m.videoFetchingTask.control = "run"
end function

sub GettingError()
    if m.query = "Trending"
        if(m.getTrandingVideo.error = "error")
            reloadAgain()
        end if
    else
        if(m.videoFetchingTask.error = "error")
            reloadAgain()
        end if
    end if
end sub

sub reloadAgain()
    print "Error handle options"
    dialog = createObject("roSGNode", "Dialog")
    dialog.title = "Error"
    dialog.message = "Some thing went wrong! Please Try Again "
    dialog.buttons = ["Reload"]
    dialog.ObserveField("buttonSelected", "reloadButtonSelected")
    m.top.getScene().dialog = dialog
end sub

sub reloadButtonSelected(event as object)
    index = event.GetData()
    if m.top.getScene().dialog <> invalid
        m.top.getScene().dialog.close = true
    end if
    ' print "Button Index: " event.GetData()
    if index = 0
        print "reload Aggain"
        fetchVideos()
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false
    if press
        if key = "left" and m.option.hasFocus()
            m.rowList.setFocus(true)
        else if key = "right" and m.rowList.hasFocus()
            m.option.setFocus(true)

        else if key = "down" and m.rowList.hasFocus() or m.option.hasFocus()
            m.video.setFocus(true)
            m.rowList.visible = false
            m.searchQuery.visible = true

        else if key = "down" and m.video.hasFocus() and not m.butonUp.hasFocus()
            m.butonUp.setFocus(true)

        else if key = "down" and m.butonUp.hasFocus() and not m.butonDown.hasFocus()
            m.butonDown.setFocus(true)

        else if key = "up" and not m.butonDown.hasFocus()
            m.rowList.visible = true
            m.rowList.setFocus(true)
            m.searchQuery.visible = false

        else if key = "up" and m.butonDown.hasFocus()
            m.butonUp.SetFocus(true)

        else if key = "OK" and m.video.hasFocus()
            if m.video.control = "play" or m.video.control = "resume"
                m.video.control = "pause"

            else if m.video.control = "pause"
                m.video.control = "resume"
            end if


        else if key = "right" and (m.video.hasFocus() or m.butonUp.hasFocus() or m.butonDown.hasFocus())
            m.butonDown.setFocus(true)
            if m.i = m.videos.Count() - 1
                m.butonDown.visible = false
            else
                m.video.content = invalid
                'play next video
                m.i = m.i + 1
                playVideo(m.i)
            end if
            if(m.butonUp.visible = false)
                m.butonUp.visible = true
            end if

        else if key = "left" and (m.video.hasFocus() or m.butonDown.hasFocus() or m.butonUp.hasFocus())
            m.butonUp.setFocus(true)
            'play next video
            if(m.i = 0)
                m.butonUp.visible = false
            else
                m.video.content = invalid
                m.i = m.i - 1
                playVideo(m.i)
            end if
            if(m.butonDown.visible = false)
                m.butonDown.visible = true
            end if
        end if
    end if
    return handled
end function

sub moveVideoUp()
    if(m.i = 0)
        m.butonUp.visible = false
        m.butonDown.SetFocus(true)
    else
        m.video.content = invalid
        m.i = m.i - 1
        playVideo(m.i)
    end if
    if(m.butonDown.visible = false)
        m.butonDown.visible = true
    end if
end sub

sub moveVideoDown()
    if m.i = m.videos.Count() - 1
        m.butonDown.visible = false
        m.butonUp.SetFocus(true)
    else
        m.video.content = invalid
        'play next video
        m.i = m.i + 1
        playVideo(m.i)
    end if
    if(m.butonUp.visible = false)
        m.butonUp.visible = true
    end if
end sub

function RegRead(key, section = invalid)
    'print  "In reg read"
    if section = invalid section = "Default"
    sec = CreateObject("roRegistrySection", section)
    if sec.Exists(key)
        m.preferencesExists = true
        'print  "Key found " sec.Read(key)
        return sec.Read(key)
    else
        m.preferencesExists = false
        'print  "Key not found"
    end if
end function

function RegWrite(key, val, section = invalid)
    'print  "Here in reg write"
    if section = invalid section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Write(key, val)
    sec.Flush() 'commit it
    'print  "Wrote " val " to " key
end function



sub showdialog()
    dialog = createObject("roSGNode", "Dialog")
    dialog.title = "Please enter some preferences"
    dialog.optionsDialog = true
    dialog.message = "Press * To Dismiss"
    scene = m.top.getScene()
    scene.dialog = dialog
end sub


'' Working with Preferences
sub getCategoriesTask()
    m.PreferenceTask = CreateObject("roSGNode", "PreferenceTask")
    m.PreferenceTask.observeField("error", "onContentLoaded")
    m.PreferenceTask.control = "run"
end sub
sub onContentLoaded()
    if m.PreferenceTask.error = "ok"
        m.rowList.content = m.PreferenceTask.content
    else
    end if
end sub

sub OnVisibleChange() ' invoked when GridScreen change visibility
    if m.top.visible = true
        m.rowList.SetFocus(true) ' set focus to rowList if GridScreen visible
    end if
end sub

sub OnItemClicked()
    m.checkOnItemClicked = true
    if m.checkBusySpinner = "loaded"
        m.exampleBusyspinner.visible = true
    end if
    m.video.content = invalid
    focusedIndex = m.rowList.rowItemFocused ' get position of focused item
    row = m.rowList.content.GetChild(focusedIndex[0]) ' get all items of row
    item = row.GetChild(focusedIndex[1]) ' get focused item
    print "Channel_id: " item.name
    m.i = 0
    'm.searchQuery.text = item.name
    m.query = item.name
    if item.name = "Trending"
        fetchTrandingVideos()
    else
        CheckSubscriptionAndStartPlayback()
    end if
end sub

function fetchTrandingVideos()
    m.getTrandingVideo = CreateObject("roSGNode", "getTrandingVideo")
    m.searchQuery.text = m.query
    print "Query...." m.query
    m.getTrandingVideo.ObserveField("videosArr", "videosRendered")
    m.getTrandingVideo.ObserveField("error", "GettingError")
    m.getTrandingVideo.control = "run"
end function


sub showdialogKeyboard()
    print "show KeyBoard"
    m.keyboarddialog = createObject("roSGNode", "KeyboardDialog")
    m.keyboarddialog.title = "Add Preferences"
    m.keyboarddialog.buttons = ["Add to Preferences", "Cancel"]
    m.keyboarddialog.observeField("buttonSelected", "handleKeyboardDialog")
    m.keyboarddialog.observeField("wasClosed", "handleKeyboardDialog")
    'm.top.dialog = m.keyboarddialog
    scene = m.top.getScene()
    scene.dialog = m.keyboarddialog
end sub

sub handleKeyboardDialog(event as object)
    print "Keyboad Dialog is closed"
    if(m.video.control = "pause")
        m.video.control = "resume"
    end if
    button = event.getData()
    if m.top.getScene().dialog <> invalid
        m.top.getScene().dialog.close = true

    end if
    if button = 0
        addNewPreferences(m.keyboarddialog.text)

    else if button = 1
        m.top.getScene().dialog.close = true
    end if
end sub

function addNewPreferences(keyText as string)
    print " Ading Keyboard "
    checkNewPrefer = false
    recentArr = []
    obj = {}
    recent = RegRead("defaltPreferences")
    if recent <> "" and recent <> invalid
        recent = ParseJson(recent)
        print recent
        obj.name = keyText
        for each item in recent
            recentArr.Push(item)
            print "here is search Result " item
        end for
        i = 0
        for each item in recentArr
            if(item.name = obj.name)
                checkNewPrefer = true
            end if
            i++
        end for
        if(checkNewPrefer = false)
            recentArr.Push(obj)
        end if
        RegWrite("defaltPreferences", formatJson(recentArr))
        getCategoriesTask()
    end if

end function