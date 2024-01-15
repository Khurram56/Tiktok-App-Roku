' Channel entry point
sub Main()
    ShowChannelRSGScreen()
end sub

sub ShowChannelRSGScreen()
    screen = CreateObject("roSGScreen")
    msgPort = CreateObject("roMessagePort")

    input = CreateObject("roInput")
    input.SetMessagePort(msgPort)

    ' 'print  "Waiting for messages..."
    scene = screen.CreateScene("MainScene")
    screen.Show() ' Init method in MainScene.brs is invoked
    scene.signalBeacon("AppLaunchComplete")
    while true
        msg = wait(0, msgPort)
        if type(msg) = "roInputEvent"
            if msg.IsInput()
                info = msg.GetInfo()
                ' 'print  "Received input: "; FormatJSON(info)
            end if
        end if
    end while
end sub
