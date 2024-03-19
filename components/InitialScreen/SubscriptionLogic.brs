sub CheckSubscriptionAndStartPlayback()
    RunSubscriptionFlow()
    print "CheckSubscriptionAndStartPlayback: run"
end sub

sub RunSubscriptionFlow()
    m.exampleBusyspinner.visible = true
    m.isProductWithExpiredTrial = false
    print "RunSubscriptionFlow: run"
    m.global.channelStore.command = "getPurchases"
    m.global.channelStore.ObserveField("purchases", "OnGetPurchases")
end sub

sub OnGetPurchases(event as object)
    print "OnGetPurchases: run"
    m.global.channelStore.UnobserveField("purchases")
    purchases = event.GetData() 
    print "number of Purchases: " purchases.GetChildCount().toStr()
    if purchases.GetChildCount() > 0 
        allPurchases = purchases.GetChildren(-1, 0)
        print "allPurchases: " allPurchases
        datetime = CreateObject("roDateTime")
        utimeNow = datetime.AsSeconds()
        for each purchase in allPurchases
            datetime.FromISO8601String(purchase.expirationDate)
            utimeExpire = datetime.AsSeconds()
            print "Already in Purchases: " purchase.code

            if utimeExpire > utimeNow and purchase.code="2.0_tiktok_basic" or purchase.code="2.0_tiktok_premium"
                PackgeSubscraption()
                return
            end if

        end for
    end if
    print "Retraving Products.."
    dailyFreeTrail()    
end sub

sub getAvailiableProducts()
    print "searching products"
    m.exampleBusyspinner.visible = false
    dialogCheckProducts = CreateObject("roSGNode", "ProgressDialog")

    dialogCheckProducts.title = "Retrieving available products..."
    scene = m.top.getScene()
    scene.dialog = dialogCheckProducts 
    m.global.channelStore.command = "getCatalog"
    m.global.channelStore.ObserveField("catalog", "OnGetCatalog")
end sub

sub OnGetCatalog(event as object)
    m.global.channelStore.UnobserveField("catalog")
    catalog = event.GetData()
    print "here is the subs : "catalog.GetChildren(-1, 0)
    if m.top.getScene().dialog <> invalid
        m.top.getScene().dialog.close = true 
    else
        return
    end if
    dialog = CreateObject("roSGNode", "Dialog")
    if catalog.GetChildCount() > 0
        dialog.title = "Subscriptions"
        dialog.message = "Please select subscription type:"
        subscriptions = []
        m.activeCatalogItems = []
        for each product in catalog.GetChildren(-1, 0)
            subscriptions.Push(product.name + " " + product.cost)
            print " product cost =============> "product.cost
            m.activeCatalogItems.Push({
                code: product.code,
                name: product.name
            })
            print "Product name : "product.name
            print "Product code : "product.code
        end for
        print "Here is the Subscraption: "subscriptions
        dialog.buttons = subscriptions 
        dialog.ObserveField("buttonSelected", "DoSubscriptionOrder")
    else
        dialog.title = "Error"
        dialog.message = "There are not any available subscriptions for now..."
    end if
    scene = m.top.getScene()
    scene.dialog = dialog
end sub

sub DoSubscriptionOrder(event as object)
    buttonSelectedIndex = event.getData()
    catalogItem = m.activeCatalogItems[buttonSelectedIndex]
    print "click item " catalogItem.name + catalogItem.code
    order = CreateObject("roSGNode", "ContentNode")
    product = order.CreateChild("ContentNode")
    product.AddFields({ code: catalogItem.code, name: catalogItem.name, qty: 1 })
    m.global.channelStore.order = order
    m.global.channelStore.command = "doOrder"
    m.global.channelStore.ObserveField("orderStatus", "OnOrderStatus")
end sub

sub OnOrderStatus(event as object)
    orderStatus = event.GetData()
    print "order Status" orderStatus
    if orderStatus <> invalid and orderStatus.status = 1
        PackgeSubscraption()
    else
        dialog = CreateObject("roSGNode", "Dialog")
        dialog.title = "Error"
        dialog.message = "Failed to process your payment. Please try again."
        scene = m.top.getScene()
        scene.dialog = dialog '
    end if
    m.global.channelStore.UnobserveField("orderStatus")
end sub

function getCountDays()
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
        RegWrite("noOfDays", FormatJson(0))
        print "Adding defalt"
    else
        previusDate = ParseJson(RegRead("previusDate"))
        if m.currentDate <> previusDate
            previusDate = m.currentDate
            saveDays = ParseJson(RegRead("noOfDays"))
            saveDays = saveDays + 1
            print "saved Data Days:" saveDays
            RegWrite("noOfDays", FormatJson(saveDays))
            RegWrite("previusDate", FormatJson(previusDate))
            print "just one time a Day"
            print "SavedDataDays: " ParseJson(RegRead("noOfDays"))
            print "previus Data Days: " ParseJson(RegRead("previusDate"))
        end if
    end if
end function

sub showAlertDialog()
    dialog = CreateObject("roSGNode", "Dialog")
    dialog.title = "Alert"
    dialog.message = "Your Monthly requests has been completed!"
    'dialog.observeField("wasCancel","limtAlertHandle")
    scene = m.top.getScene()
    scene.dialog = dialog
end sub

sub yearlyPakgeSubscraption()
    getCountDays()
    RegRead("apiRequists")
    if m.preferencesExists = false
        RegWrite("apiRequists", FormatJson(2))
        print "2 Time Api Call"
        if m.checkOnItemClicked = true
            fetchVideos()
            m.checkOnItemClicked = false
        else
            fetchMoreVideos()
        end if
    else if ParseJson(RegRead("apiRequists")) <= 300
        noOfCalls = ParseJson(RegRead("apiRequists"))
        RegWrite("apiRequists", FormatJson(noOfCalls + 1))
        print "Again Api Called: " noOfCalls.toStr()
        if m.checkOnItemClicked = true
            fetchVideos()
            m.checkOnItemClicked = false
        else
            fetchMoreVideos()
        end if
    else if ParseJson(RegRead("saveDataDays")) <= 30 and ParseJson(RegRead("apiRequists")) >= 300
        print "package Expire try Next month"
        showAlertDialog()
    else if ParseJson(RegRead("saveDataDays")) = 30
        RegWrite("apiRequists", FormatJson(1))
    else
        print "pakge Expire"
        showAlertDialog()
    end if
end sub

sub PackgeSubscraption()
        if m.checkOnItemClicked = true   ' check rowlist item clicked
            fetchVideos()
            m.checkOnItemClicked = false
        else if m.checkOnAddButtonClicked = true 'check if add preference button clicked
            m.exampleBusyspinner.visible = false
            showdialogKeyboard()
            m.checkOnAddButtonClicked = false 
        else
            fetchMoreVideos() 'load more videos
        end if
end sub

sub checkSubscription()
    print "Subscription button clicked"
    getAvailiableProducts()
end sub
