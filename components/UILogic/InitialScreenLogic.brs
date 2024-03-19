sub ShowInitialScreen()
    print " initial screen "
    m.initialScreen = CreateObject("roSGNode", "InitialScreen")
    m.initialScreen.ObserveField("optionButtonSelected","ShowRateUsScreen")
    m.initialScreen.ObserveField("subscribeButtonSelected","ShowSubscriptionScreen")
    m.initialScreen.ObserveField("subscription_expired", "subscriptionScreenMenu")
    m.posterSplash.visible = "false"
    ShowScreen(m.initialScreen) 
end sub

sub ShowF_BScreen()
    print "here is ShowF_BScreen "
    m.feedbackscreeen = CreateObject("roSGNode", "RateUsScreen")
    m.feedbackscreeen.ObserveField("settingsButtonSelected","feedBackScreen1")
    m.posterSplash.visible = "false"
    ShowScreen(m.feedbackscreeen) 
end sub

sub handleOptions()
    print "Handle options"
    dialog = createObject("roSGNode", "Dialog")
    dialog.title = "Options"
    dialog.buttons = ["How To Use", "Feedback","Subscription"]
    dialog.ObserveField("buttonSelected", "onOptionsButtonSelected")
    m.top.getScene().dialog = dialog
end sub

sub handleFeedBack()
    print "Handle feedback"
    dialog = createObject("roSGNode", "Dialog")
    dialog.title = "Feedback"
    dialog.buttons = ["How To Use", "Feedback","Subscription"]
    dialog.ObserveField("buttonSelected", "onFeedbackButtonSelected")
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
        ShowRateUsScreen()
    else if index = 2
        'show  products
        m.initialScreen.subscriptionDialog = "changed"
    end if
end sub

sub onFeedbackButtonSelected(event as object)
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
        feedBackScreen1()
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

sub ShowRateUsScreen()
    m.feedBackScreen = CreateObject("roSGNode", "RateUsScreen")
    m.feedBackScreen.ObserveField("settingsButtonSelected","feedBackScreen1")
    m.feedBackScreen.ObserveField("ctg_ButtonSelected","subscriptionScreenMenu")

    ShowScreen(m.feedBackScreen)

end sub

sub ShowSubscriptionScreen()
    m.subscriptionScreen = CreateObject("roSGNode", "subscription")
    ShowScreen(m.subscriptionScreen)

end sub

sub feedBackScreen1()
    m.busyspinner.visible = false
    m.feedBackScreen = CreateObject("roSGNode", "FeedbackScreen")
    m.feedBackScreen.ObserveField("goBackBtn", "GoBack")
    ShowScreen(m.feedBackScreen)
    print "here i ma in feedback"
end sub

sub subscriptionScreenMenu()
    print " subscriptionScreenMenu called trough UI logic"
    m.subscriptionScreen = CreateObject("roSGNode", "subscription")
    ShowScreen(m.subscriptionScreen)
end sub



