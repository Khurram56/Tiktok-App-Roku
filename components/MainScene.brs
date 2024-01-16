sub init()
    ' RegDelete("defaltPreferences")
    ' RegDelete("defaltSavedVideo")
    InitScreenStack()
    m.currentDate = 0
    m.top.backgroundURI = ""
    m.top.backgroundColor = "#2f222c"
    m.posterSplash = m.top.findNode("posterSplash")
    'getCurrentTime()
    getBusySpinner()
    onOfflineChanged()
    m.loadingIndecator = m.top.findNode("loadingIndecator")
    m.loadingIndecator.visible = false
    'create store for Subscription
    m.global.AddField("channelStore", "node", false)
    m.global.channelStore = CreateObject("roSGNode", "ChannelStore")

end sub

sub getBusySpinner()
    m.busyspinner = m.top.findNode("exampleBusySpinner")
    m.busyspinner.poster.observeField("loadStatus", "showspinner")
    m.busyspinner.poster.uri = "pkg:/images/busyspinner_hd.png"

end sub

function OnkeyEvent(key as string, press as boolean) as boolean
    result = false
    if press
        ' handle "back" key press
        if key = "back"
            numberOfScreens = m.screenStack.Count()
            ' close top screen if there are two or more screens in the screen stack
            if numberOfScreens > 1
                CloseScreen(invalid)
                result = true
            end if
        end if
    end if
    return result
end function

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

function RegDelete(key, section = invalid)
    if section = invalid section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Delete(key)
    sec.Flush()
end function


sub GoBack()
    numberOfScreens = m.screenStack.Count()
    ' close top screen if there are two or more screens in the screen stack
    if numberOfScreens > 1
        CloseScreen(invalid)
        result = true
    end if
end sub

function defaltPreferences()
    favourites = []
    object2 = {}
    object = {}
    object1 = {}
    object3 = {}
    object4 = {}
    object5 = {}
    object1.name = "Trending"
    favourites.push(object1)
    object4.name = "ForYou"
    favourites.push(object4)
    object.name = "Top"
    favourites.push(object)
    object2.name = "Comedy"
    favourites.push(object2)
    object3.name = "Animation"
    favourites.push(object3)
    object5.name = "Gaming"
    favourites.push(object5)
    file = WriteAsciiFile("tmp:/prefer.txt", formatJson(favourites))
    print ReadAsciiFile("tmp:/prefer.txt")
    RegWrite("defaltPreferences", FormatJson(favourites))

end function

function RegWrite(key, val, section = invalid)
    'print  "Here in reg write"
    if section = invalid section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Write(key, val)
    sec.Flush() 'commit it
    'print  "Wrote " val " to " key
end function

'' Featch Videos
function fetchVideos()
    p = RegRead("defaltSavedVideo")
    print "Preferences exists " FormatJson(p)
   if m.preferencesExists = false
        m.videoFetchingTask = CreateObject("roSGNode", "getTrandingVideo")
        m.videoFetchingTask.ObserveField("videosArr", "GettingVideos")
        m.videoFetchingTask.ObserveField("error", "GettingError")
        m.videoFetchingTask.control = "run"
    else
        file = WriteAsciiFile("tmp:/videos.txt", p)
        print"saved File: " file
        ShowInitialScreen()
        print "saved Videos"
    end if
end function

sub GettingVideos()
    RegWrite("defaltSavedVideo", ReadAsciiFile("tmp:/videos.txt"))
    ShowInitialScreen()

end sub

sub GettingError()
    if(m.videoFetchingTask.error = "error")
        reloadAgain()
    end if
end sub

sub showspinner()
    if(m.busyspinner.poster.loadStatus = "ready")
        centerx = (1280 - m.busyspinner.poster.bitmapWidth) / 2
        centery = (720 - m.busyspinner.poster.bitmapWidth) / 2
        m.busyspinner.translation = [centerx, centery]

        m.busyspinner.visible = true
    end if
end sub


function onOfflineChanged()
    if(m.top.offline)
        m.loadingIndecator.text = "Kindly Check Your Internet Cunnaction"
        print "We are OFFline."
    else
        p = RegRead("defaltPreferences")
        print "Preferences exists " FormatJson(p)
        if m.preferencesExists = false
            defaltPreferences()
            fetchVideos()
            print "Adding defalt"
        else

            fetchVideos()
            print "Show Defalt Prefere"
            'PlayVideo()
        end if
        print "We are ONline."
    end if
end function

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
    if m.top.dialog <> invalid
        m.top.dialog.close = false
    end if
    ' print "Button Index: " event.GetData()
    if index = 0
        print "reload Aggain"
        fetchVideos()
    end if
end sub


