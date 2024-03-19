sub init()
    m.poster = m.top.findNode("poster")
    m.poster1 = m.top.findNode("poster1")
    m.poster2= m.top.findNode("poster2")
    m.tittle = m.top.findNode("tittle")
    m.basic = m.top.findNode("basic")
    'm.book_now = m.top.findNode("book_now")
    m.basic_cost = m.top.findNode("basic_cost")
    m.premium_cost = m.top.findNode("premium_cost")
    m.poster3= m.top.findNode("poster3")
    m.poster4 = m.top.findNode("poster4")
    m.Standard = m.top.findNode("Standard")
    m.book_now1 = m.top.findNode("book_now1")

    m.poster5= m.top.findNode("poster5")
    m.poster6 = m.top.findNode("poster6")
    m.Premium = m.top.findNode("Premium")
    m.book_now2 = m.top.findNode("book_now2")

    'm.book_now.observeField("buttonSelected", "onFreemiumButtonClicked")
    m.book_now1.observeField("buttonSelected", "onBasicButtonClicked")
    m.book_now2.observeField("buttonSelected", "onPremiumButtonClicked")
    RunSubscriptionFlow()
end sub

' sub onFreemiumButtonClicked()
'     print " Freemium Button Clicked"
'     dialog = CreateObject("roSGNode", "Dialog")
'     dialog.title = "Subscription"
'     dialog.message = "You have already subscribed to Freemium service! "
'     dialog.buttons = ["Cancel"]
'     dialog.observeField("buttonSelected", "DailyLimtDialogButtonSelected")
'     scene = m.top.getScene()
'     scene.dialog = dialog
' end sub

sub DailyLimtDialogButtonSelected(event as object)
    button = event.getData()
    if m.top.getScene().dialog <> invalid
        m.top.getScene().dialog.close = true
    end if
    if button = 0
        m.top.getScene().dialog.close = true
    end if
end sub

sub onBasicButtonClicked()
    print " Standard Button Clicked"
    order = CreateObject("roSGNode", "ContentNode")
    product = order.CreateChild("ContentNode")
    basic_product_code = "2.0_tiktok_basic"
    basic_product_name = "TikTok Basic"
    product.AddFields({ code: basic_product_code, name: basic_product_name, qty: 1 })
    m.global.channelStore.order = order
    m.global.channelStore.command = "doOrder"
    m.global.channelStore.ObserveField("orderStatus", "OnOrderStatus")
end sub

sub onPremiumButtonClicked()
    print " Premium Button Clicked"
    order = CreateObject("roSGNode", "ContentNode")
    product = order.CreateChild("ContentNode")
    basic_product_code = "2.0_tiktok_premium"
    basic_product_name = "TikTok Premium"
    product.AddFields({ code: basic_product_code, name: basic_product_name, qty: 1 })
    m.global.channelStore.order = order
    m.global.channelStore.command = "doOrder"
    m.global.channelStore.ObserveField("orderStatus", "OnOrderStatus")
end sub

sub OnOrderStatus(event as Object)
        orderStatus = event.GetData()
        if orderStatus <> invalid and orderStatus.status = 1
            ' if order has been processed successfully then show
            'fetchVideos()
        else
            ' otherwise show error dialog
            m.dialog = CreateObject("roSGNode", "Dialog")
            m.dialog.title = "Error"
            m.dialog.message = "Failed to process your payment. Please try again."
            m.top.dialog = m.dialog
        end if
        m.global.channelStore.UnobserveField("orderStatus")
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if press then
        if key = "down" 
            m.book_now1.setFocus(true)
            result = true
        else if key = "right" and m.book_now1.hasFocus()
            m.book_now2.setFocus(true)
            m.poster5.uri = "pkg:/images/stndard_back.png"
            m.poster3.uri =  "pkg:/images/rectangle_subscription.png"
            result = true
        else if key = "left" and m.book_now2.hasFocus()
            m.book_now1.setFocus(true)
            m.poster3.uri = "pkg:/images/stndard_back.png"
            m.poster5.uri =  "pkg:/images/rectangle_subscription.png"
            result = true
        ' else if key = "right" and m.book_now1.hasFocus()
        '     m.book_now2.setFocus(true)
        '     result = true
        ' else if key = "left" and m.book_now2.hasFocus()
        '     m.book_now1.setFocus(true)
        '     result = true
        end if
    end if
    return result
end function


