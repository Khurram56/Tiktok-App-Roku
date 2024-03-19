sub init()
    m.top.functionName = "getContent"
end sub

sub getContent()
    m.videoArr = []
    deviceInfo = CreateObject("roDeviceInfo")
    countryCode = deviceInfo.GetUserCountryCode()
    m.top.error = "ok"
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    if countryCode <> "OT" and countryCode <> "ot"
        url = "https://tiktok-scraper7.p.rapidapi.com/feed/list?region=" + countryCode + "&count=20"
    else
        url = "https://tiktok-scraper7.p.rapidapi.com/feed/list?region=US&count=20"
    end if

    print "Url: " url
    xfer.SetURL(url)
    xfer.AddHeader("X-RapidAPI-Host", "tiktok-scraper7.p.rapidapi.com")
    xfer.AddHeader("X-RapidAPI-Key", "5d5f123215mshe2de294047c807ep14997ejsnae4da76a4c07")
   ' xfer.AddHeader("X-RapidAPI-Key", "486a89c811msh54ba0256b830a5ap13199cjsndf2db2fc4aa2")
    xfer.InitClientCertificates()
    rsp = xfer.GetToString()
    'print "rsp: " rsp
    json = ParseJson(rsp)
    if json <> invalid
        if json.data <> invalid
            json = json.data
            for each item in json
                video = item.play
                'print "Video Url: "video
                m.videoArr.Push(video)
            end for
            m.videoArr = FormatJson(m.videoArr)
            file = WriteAsciiFile("tmp:/videos.txt", m.videoArr)
            m.top.videosArr = "changed"
        else
            print "Error occure"
            m.top.error = "error"
        end if
    else
        print "Error occure"
        m.top.error = "error"
    end if
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

