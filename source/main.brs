sub Main()
    ShowChannelRSGScreen()
  end sub
  
  sub ShowChannelRSGScreen()
    ' The roSGScreen object is a SceneGraph canvas that displays the contents of a Scene node instance
    screen = CreateObject("roSGScreen")
    ' message port is the place where events are sent
    m.port = CreateObject("roMessagePort")
    ' sets the message port which will be used for events from the screen
    screen.SetMessagePort(m.port)
    ' every screen object must have a Scene node, or a node that derives from the Scene node
    scene = screen.CreateScene("MainScene")
    screen.Show() ' Init method in MainScene.brs is invoked
    'observe the appExit event to know when to kill the channel
    scene.observeField("appExit", m.port)
    'focus the scene so it can respond to key events
    'scene.setFocus(true)
  
  
    ' event loop
    while true
      msg = wait(0, m.port)
      msgType = type(msg)
  
      if msgType = "roSGScreenEvent" then
        if msg.isScreenClosed() then
          return
        end if
      'respond to the appExit field on MainScene
      else if msgType = "roSGNodeEvent" then
        field = msg.getField()
        'if the scene's appExit field was changed in any way, exit the channel
        if field = "appExit" then
          return
        end if
      end if
    end while
  end sub