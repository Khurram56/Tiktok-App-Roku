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
        videoContent = createObject("RoSGNode", "ContentNode")
        videoContent.url = m.videos[i]
        videoContent.streamformat = "mp4"
        m.video.content = videoContent
        m.video.control = "play"
        m.video.ObserveField("state", "OnVideoStateChange")
        if m.videosLength - 2 = i
            CheckSubscriptionAndStartPlayback()
        end if
    end if
end sub

sub dailyFreeTrail()
    ' getDailyFactoryUpdate() 'every day refrash the freeTrail Registery
    ' if ParseJson(RegRead("freeTrail")) <= 4
        ' 'm.availiableFreeTrail = true
        ' freeTrail = ParseJson(RegRead("freeTrail"))
        ' RegWrite("freeTrail", FormatJson(freeTrail + 1))
        ' print "No of Api Calls Api Called : " ParseJson(RegRead("freeTrail"))
        ' if m.checkOnItemClicked = true
        '     fetchVideos()
        '     m.checkOnItemClicked = false
        ' else if m.checkOnAddButtonClicked = true
        '     getAvailiableProducts()
        '     m.checkOnAddButtonClicked = false
        ' else
        '     fetchMoreVideos()
        ' end if

        getDailyFactoryUpdate2()
            m.a = RegRead("count_videos")
            if m.a <> invalid
                print "valid "
                m.a = m.a.toInt()
            else
                print "Registry value not found or is invalid"
                m.a = 0
            end if
            if m.a < 10
                ' m.video.content = invalid
                ' print " Number of Videos Played :::"m.a
                ' 'play next video
                ' m.a =m.a + 1
                ' RegWrite("count_videos", FormatJson(m.a))
                ' playVideo(m.a)
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
    m.video.control = "pause"
   print "***************** daily limit reached *******************"
   m.top.subscription_expired= "abc"
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

sub getDailyFactoryUpdate()
    rawTime = CreateObject("roDateTime")
    rawTime.ToLocalTime()
    stringedTime = rawTime.ToISOString()
    print "Current Time is: " + stringedTime
    arr = stringedTime.split("-")
    currentDate = arr[2].toInt()
    print "Date: " + currentDate.ToStr()
    previusDate = RegRead("previusDate")
    if previusDate = invalid
        RegWrite("previusDate", FormatJson(1))
        RegWrite("freeTrail", FormatJson(1))
        print "One time when channel was downloaded"
    else
        previusDate = ParseJson(previusDate)
        if currentDate <> previusDate
            RegWrite("previusDate", FormatJson(currentDate))
            print "One Time a Day"
            RegWrite("freeTrail", FormatJson(2))
        end if
    end if
end sub

sub getDailyFactoryUpdate2()
    rawTime = CreateObject("roDateTime")
    rawTime.ToLocalTime()
    stringedTime = rawTime.ToISOString()
    print "Current Time is: " + stringedTime
    arr = stringedTime.split("-")
    currentDate = arr[2].toInt()
    print "Date: " + currentDate.ToStr()
    previusDate = RegRead("previusDate")
    if previusDate = invalid
        RegWrite("previusDate", FormatJson(1))
        RegWrite("count_videos", FormatJson(1))
        print "One time when channel was downloaded"
    else
        previusDate = ParseJson(previusDate)
        if currentDate <> previusDate
            RegWrite("previusDate", FormatJson(currentDate))
            print "One Time a Day"
            RegWrite("count_videos", FormatJson(2))
        end if
    end if
end sub

function OnVideoStateChange()
    if m.video.state = "finished"
        if m.i = m.videos.Count() - 1
            m.butonDown.visible = true
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