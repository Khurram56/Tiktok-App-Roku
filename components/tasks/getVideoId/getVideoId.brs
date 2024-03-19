sub init()
    m.top.functionName = "getContent"
end sub

sub getContent()
    deviceInfo = CreateObject("roDeviceInfo")
    countryCode = deviceInfo.GetUserCountryCode()
    m.top.error = "ok"
    print "Returned preferences: " m.top.preferences
    file = ReadAsciiFile("tmp:/videos.txt")
    offset = ReadAsciiFile("tmp:/offset.txt")
    ' print "Here: " m.top.changes
    ' print "Prefences: " m.top.preferences
    if m.top.changes = "true"
        print "Add more Videos"
        if file <> ""
            print "Fetching Again"
            file = ParseJson(file)
            m.videoArr = file
            offset = offset.toInt()
            offset += 30
        end if
    else
        print "new Videos"
        m.videoArr = []
        offset = 0

    end if
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    'print  "Offset Type: " + Type(offset)
    offset = offset.toStr()
    if countryCode <> "OT" and countryCode <> "ot"
        url = "https://tiktok-scraper7.p.rapidapi.com/feed/search?keywords=" + m.top.preferences + "&region=" + countryCode + "&count=500&cursor=" + offset + "&publish_time=0&sort_type=0"
    else
        url = "https://tiktok-scraper7.p.rapidapi.com/feed/search?keywords=" + m.top.preferences + "&count=500&cursor=" + offset + "&publish_time=0&sort_type=0"
    end if

    print "Url: " url
    xfer.SetURL(url)
    xfer.AddHeader("X-RapidAPI-Host", "tiktok-scraper7.p.rapidapi.com")
    xfer.AddHeader("X-RapidAPI-Key", "5d5f123215mshe2de294047c807ep14997ejsnae4da76a4c07")
    'xfer.AddHeader("X-RapidAPI-Key", "486a89c811msh54ba0256b830a5ap13199cjsndf2db2fc4aa2")
    xfer.InitClientCertificates()
    rsp = xfer.GetToString()
    'print "rsp: " rsp
    json = ParseJson(rsp)
    if json <> invalid
        if json.data <> invalid
            json = json.data
            for each item in json.videos
                video = item.play
                'print "Video Url: "video
                m.videoArr.Push(video)
            end for
            m.videoArr = FormatJson(m.videoArr)
            file = WriteAsciiFile("tmp:/videos.txt", m.videoArr)
            offset = WriteAsciiFile("tmp:/offset.txt", offset)
            m.top.videosArr = "changed"
        else
            print "Error occure"
            m.top.error = "error"
        end if
    else
        print "Error occure"
        m.top.error = "error"
    end if
    'print  "Done Fetching"
end sub


function RegWrite(key, val, section = invalid)
    'print  "Here in reg write"
    if section = invalid section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Write(key, val)
    sec.Flush() 'commit it
    'print  "Wrote " val " to " key
end function

function RegRead(key, section = invalid)
    'print  "In reg read"
    if section = invalid section = "Default"
    sec = CreateObject("roRegistrySection", section)
    if sec.Exists(key)
        'print  "Key found " sec.Read(key)
        return sec.Read(key)
    else
        'print  "Key not found"
    end if
    return invalid
end function

