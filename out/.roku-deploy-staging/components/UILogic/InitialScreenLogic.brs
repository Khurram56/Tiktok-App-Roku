sub ShowInitialScreen()
    m.initialScreen = CreateObject("roSGNode", "InitialScreen")
    m.initialScreen.ObserveField("optionButtonSelected","ShowFeedBackScreen")
    m.posterSplash.visible = "false"
    ShowScreen(m.initialScreen) 
end sub

sub handleOptions()
    print "Handle options"
    dialog = createObject("roSGNode", "Dialog")
    dialog.title = "Options"
    dialog.buttons = ["How To Use", "Feedback","Subscription"]
    dialog.ObserveField("buttonSelected", "onOptionsButtonSelected")
    m.top.getScene().dialog = dialog
end sub



sub onOptionsButtonSelected(event as object)
    index = event.GetData()
    if m.top.dialog <> invalid
        m.top.dialog.close = false
    end if
    ' print "Button Index: " event.GetData()
    if index = 0
        print "How to Use"
        ShowEditPreferencesScreen()
    else if index = 1
        print "Feedback"
        ShowFeedBackScreen()
    else if index = 2
        'show  products
        m.initialScreen.subscriptionDialog = "changed"
    end if
end sub

sub ShowEditPreferencesScreen()
    m.showEditPreferencesScreen = CreateObject("roSGNode", "InstractionScreen")
    m.busyspinner.visible = "false"
    'm.showEditPreferencesScreen.ObserveField("doneBtn", "BackToVideo")
    ShowScreen(m.showEditPreferencesScreen)
end sub

sub ShowFeedBackScreen()
    m.feedBackScreen = CreateObject("roSGNode", "FeedbackScreen")
    m.feedBackScreen.ObserveField("goBackBtn", "GoBack")
    ShowScreen(m.feedBackScreen)
end sub

' sub PlayVideoButtonPressed()
'     if m.initialScreen.signal = "ok"
'         'print  "In playing video"
'         m.screen = "videoscreen"
'         m.videoPlayer = CreateObject("roSGNode", "VideoScreen")
'         ShowScreen(m.videoPlayer) ' show video player screen
'     end if
' end sub

' sub PlayVideo()
'     if m.source = "ok"
'         'print  "In playing video"
'         m.screen = "videoscreen"
'         m.videoPlayer = CreateObject("roSGNode", "VideoScreen")
'         ShowScreen(m.videoPlayer) ' show video player screen
'     end if
' end sub
