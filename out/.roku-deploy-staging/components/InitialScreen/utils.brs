sub videosRendered()
    m.video.visible = true
    m.videos = ReadAsciiFile("tmp:/videos.txt")
    RegWrite("defaltSavedVideo", ReadAsciiFile("tmp:/videos.txt")) 'save on defalt saved Videos
    m.videos = ParseJson(m.videos)
    m.videosLength = m.videos.Count() - 1
    if m.checkBusySpinner = "loaded"
        m.exampleBusyspinner.visible = false
    end if
    if m.video.content <> invalid
        m.video.content = "invalid"
    end if
    playVideo(m.i)
end sub

sub playVideo(i as integer)
    if m.checkSpinner = "loaded"
        m.busyspinner.visible = true
    end if
    if m.videos[i] <> invalid
        print "Url of played Video: " m.videos[i]
        videoContent = createObject("RoSGNode", "ContentNode")
        videoContent.url = m.videos[i]
        videoContent.streamformat = "mp4"
        m.video.content = videoContent
        m.video.control = "play"
        m.video.ObserveField("state", "OnVideoStateChange")
        if m.videosLength - 2 = i
            'dailyFreeTrail()
            CheckSubscriptionAndStartPlayback() 'check subscraption
        end if
    end if
end sub

sub dailyFreeTrail()
    'm.availiableFreeTrail = false
    getDailyFectoryUpdate() 'every day refrash the freeTrail Registery

    if ParseJson(RegRead("freeTrail")) <= 15
        'm.availiableFreeTrail = true
        freeTrail = ParseJson(RegRead("freeTrail"))
        RegWrite("freeTrail", FormatJson(freeTrail + 1))
        print "no ofApi Call Api Called" ParseJson(RegRead("freeTrail"))
        if m.checkOnItemClicked = true
            fetchVideos()
            m.checkOnItemClicked = false
        else if m.checkOnAddButtonClicked = true
            getAvailiableProducts()
            m.checkOnAddButtonClicked = false
        else
            fetchMoreVideos()
        end if
    else
        print "Limit Reached :"
        dailyLimitExpireDialog()
    end if
end sub

sub dailyLimitExpireDialog()
    m.exampleBusyspinner.visible = false
    dialog = CreateObject("roSGNode", "Dialog")
    dialog.title = "Subscription"
    dialog.message = "Upgrade to a subscription for endless access to videos and entertainment! "
    dialog.buttons = ["Cancel", "Buy Subscraption"]
    dialog.observeField("buttonSelected", "DailyLimtDialogButtonSelected")
    scene = m.top.getScene()
    scene.dialog = dialog
end sub


sub DailyLimtDialogButtonSelected(event as object)
    button = event.getData()
    if m.top.getScene().dialog <> invalid
        m.top.getScene().dialog.close = true
    end if
    if button = 0
        m.top.getScene().dialog.close = true
    else if button = 1
        getAvailiableProducts()
    end if
end sub



sub getDailyFectoryUpdate()
    rawTime = CreateObject("roDateTime")
    rawTime.ToLocalTime()
    stringedTime = rawTime.ToISOString()
    print "Current Timae is: " stringedTime
    arr = stringedTime.split("-")
    conste = arr[2]
    time = conste.split("T")
    m.currentDate = time[0].toInt()
    print "print "m.currentDate

    RegRead("previusDate")
    if m.preferencesExists = false
        RegWrite("previusDate", FormatJson(1))
        RegWrite("freeTrail", FormatJson(1))
        print "one time when channel Download"
    else
        previusDate = ParseJson(RegRead("previusDate"))
        if m.currentDate <> previusDate
            previusDate = m.currentDate
            RegWrite("previusDate", FormatJson(previusDate))
            print "One Time a Day"
            RegWrite("freeTrail", FormatJson(2))
        end if
    end if
end sub

function OnVideoStateChange()
    if m.video.state = "finished"
        if m.i = m.videos.Count() - 1
            m.butonDown.visible = false
        else
            m.butonDown.visible = true
            m.i++
            playVideo(m.i)
        end if
    end if
    if(m.video.state = "playing")
        print "playing Video"
        m.busyspinner.visible = false
    end if

    if(m.video.state = "error")
        reloadAgain()
    end if
end function



function fetchMoreVideos()
    if m.checkBusySpinner = "loaded"
        m.exampleBusyspinner.visible = false
    end if
    if m.query = "Trending"
        fetchTrandingVideos()
    else
        m.searchQuery.text = m.query
        m.moreVideoFetchingTask = CreateObject("roSGNode", "GetVideos")
        m.moreVideoFetchingTask.changes = "true"
        m.moreVideoFetchingTask.preferences = m.query
        m.moreVideoFetchingTask.ObserveField("videosArr", "SetVideosUrl")
        m.moreVideoFetchingTask.control = "run"
    end if
end function

function SetVideosUrl()
    m.videos = ReadAsciiFile("tmp:/videos.txt")
    RegWrite("defaltSavedVideo", ReadAsciiFile("tmp:/videos.txt"))
    m.videos = ParseJson(m.videos)
    m.videosLength = m.videos.Count() - 1
end function