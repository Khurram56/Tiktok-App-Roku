sub CheckSubscriptionAndStartPlayback()

    RunSubscriptionFlow()
    print "CheckSubscriptionAndStartPlayback: run"
end sub

sub RunSubscriptionFlow()
    ' flag needed to show the trial for a new user
    m.exampleBusyspinner.visible = true
    m.isProductWithExpiredTrial = false

    ' show a progressive dialog while retrieving an user's purchases
    'dialogCheckSubs = CreateObject("roSGNode", "ProgressDialog")
    ' dialogCheckSubs.title = "loading...."
    ' dialogCheckSubs.message = "please wait"
    ' to show a dialog set it to the interface field of MainScene
    ' scene = m.top.getScene()
    'scene.dialog = dialogCheckSubs
    print "RunSubscriptionFlow: run"
    ' retrieve purchases by calling channelStore command
    m.global.channelStore.command = "getPurchases"
    ' set an observer to be able to handle actions once loaded
    m.global.channelStore.ObserveField("purchases", "OnGetPurchases")
end sub

sub OnGetPurchases(event as object)
    print "OnGetPurchases: run"
    m.global.channelStore.UnobserveField("purchases")
    purchases = event.GetData() ' extract loaded purchases
  
    ' check if dialog hasn't been closed before by a user
    ' if m.top.getScene().dialog <> invalid
    '     m.top.getScene().dialog.close = true ' close previous dialog
    ' else
    '     return
    ' end if
    print "number of Purchases: " purchases.GetChildCount().toStr()
    ' purchases are appended as children, so we need to check if there are some
    if purchases.GetChildCount() > 0
        ' there are some subscriptions

        ' check if there are some active subscriptions among the purchases
        allPurchases = purchases.GetChildren(-1, 0)
        print "allPurchases: " allPurchases

        ' retrieve current time in seconds
        datetime = CreateObject("roDateTime")
        utimeNow = datetime.AsSeconds()

        ' check expiration date of each purchased subscription
        for each purchase in allPurchases
            ' retrieve expiration time in seconds from the string
            datetime.FromISO8601String(purchase.expirationDate)
            utimeExpire = datetime.AsSeconds()
            print "Already in Purchases: " purchase.code
            ' if user has active subscription then show content
            ' otherwise navigate to purchase option
            if utimeExpire > utimeNow
                
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
    scene.dialog = dialogCheckProducts ' set dialog to MainScene
    ' retrieve a catalog by calling channelStore command
    m.global.channelStore.command = "getCatalog"
    ' set an observer to be able to handle actions once loaded
    m.global.channelStore.ObserveField("catalog", "OnGetCatalog")
end sub

sub OnGetCatalog(event as object)
    m.global.channelStore.UnobserveField("catalog")
    catalog = event.GetData() ' extract loaded catalog
    ' check if dialog hasn't been closed before by a user
    print "here is the subs : "catalog.GetChildren(-1, 0)
    if m.top.getScene().dialog <> invalid
        m.top.getScene().dialog.close = true ' close previous dialog
    else
        return
    end if

    dialog = CreateObject("roSGNode", "Dialog")

    ' catalog items are appended as children, so we need to check if there are some
    if catalog.GetChildCount() > 0
        ' there are some available subscription to get
        dialog.title = "Subscriptions"
        dialog.message = "Please select subscription type:"

        ' create buttons on dialog with products info
        ' to create buttons we need to create an array of strings
        subscriptions = []
        m.activeCatalogItems = []
        for each product in catalog.GetChildren(-1, 0)
            ' if trial has been already used
            subscriptions.Push(product.name + " " + product.cost)
            m.activeCatalogItems.Push({
                code: product.code,
                name: product.name

            })
            print "Product name : "product.name
            print "Product code : "product.code

            ' else     ' if trial hasn't been already used
            '     ' then show only products with trial
            '     if product.freeTrialQuantity > 0
            '         subscriptions.Push(product.name + " " + product.cost)
            '         m.activeCatalogItems.Push({
            '             code: product.code,
            '             name: product.name
            '         })
            '     end if
        end for
        print "Here is the Subscraption: "subscriptions
        dialog.buttons = subscriptions ' set buttons to dialog field
        ' set an observer to handle actions on button press
        dialog.ObserveField("buttonSelected", "DoSubscriptionOrder")
    else
        ' no available subscription to get some
        dialog.title = "Error"
        dialog.message = "There are not any available subscriptions for now..."
    end if

    scene = m.top.getScene()
    scene.dialog = dialog ' Set dialog to MainScene
end sub

' handle button press on purchase dialog
sub DoSubscriptionOrder(event as object)
    ' extract buttonSelected index from the dialog
    buttonSelectedIndex = event.getData()
    ' extract catalog item as child by index from the channelStore node
    catalogItem = m.activeCatalogItems[buttonSelectedIndex]
    print "click item " catalogItem.name + catalogItem.code

    ' to create an order we need to create a ContentNode with children as products to purchase
    order = CreateObject("roSGNode", "ContentNode")
    product = order.CreateChild("ContentNode")
    ' also we need to set required info as code, name and quantity
    product.AddFields({ code: catalogItem.code, name: catalogItem.name, qty: 1 })

    ' do an order by setting order to channelStore field and calling its command
    m.global.channelStore.order = order
    m.global.channelStore.command = "doOrder"
    ' observe orderStatus to be able to handle order response
    m.global.channelStore.ObserveField("orderStatus", "OnOrderStatus")
end sub

sub OnOrderStatus(event as object)
    orderStatus = event.GetData()
    print "order Status" orderStatus
    if orderStatus <> invalid and orderStatus.status = 1
        ' if order has been processed successfully then show
      PackgeSubscraption()

    else
        ' otherwise show error dialog
        dialog = CreateObject("roSGNode", "Dialog")
        dialog.title = "Error"
        dialog.message = "Failed to process your payment. Please try again."
        scene = m.top.getScene()
        scene.dialog = dialog '
    end if
    m.global.channelStore.UnobserveField("orderStatus")
end sub


' function getCountDays()
'     rawTime = CreateObject("roDateTime")
'     rawTime.ToLocalTime()
'     stringedTime = rawTime.ToISOString()
'     print "Current Timae is: " stringedTime
'     arr = stringedTime.split("-")
'     conste = arr[2]
'     time = conste.split("T")
'     m.currentDate = time[0].toInt()
'     print "print "m.currentDate

'     RegRead("previusDate")
'     if m.preferencesExists = false
'         RegWrite("previusDate", FormatJson(1))
'         RegWrite("noOfDays", FormatJson(0))
'         print "Adding defalt"
'     else
'         previusDate = ParseJson(RegRead("previusDate"))
'         if m.currentDate <> previusDate
'             previusDate = m.currentDate
'             saveDays = ParseJson(RegRead("noOfDays"))
'             saveDays = saveDays + 1
'             print "saved Data Days:" saveDays
'             RegWrite("noOfDays", FormatJson(saveDays))
'             RegWrite("previusDate", FormatJson(previusDate))
'             print "just one time a Day"
'             print "SavedDataDays: " ParseJson(RegRead("noOfDays"))
'             print "previus Data Days: " ParseJson(RegRead("previusDate"))
'         end if
'     end if
' end function

' sub showAlertDialog()
'     dialog = CreateObject("roSGNode", "Dialog")
'     dialog.title = "Alert"
'     dialog.message = "Your Monthly requests has been completed!"
'     'dialog.observeField("wasCancel","limtAlertHandle")
'     scene = m.top.getScene()
'     scene.dialog = dialog
' end sub

'sub yearlyPakgeSubscraption()
    ' getCountDays()
    ' RegRead("apiRequists")
    ' if m.preferencesExists = false
    '     RegWrite("apiRequists", FormatJson(2))
    '     print "2 Time Api Call"
    '     if m.checkOnItemClicked = true
    '         fetchVideos()
    '         m.checkOnItemClicked = false
    '     else
    '         fetchMoreVideos()
    '     end if
    ' else if ParseJson(RegRead("apiRequists")) <= 300
    '     noOfCalls = ParseJson(RegRead("apiRequists"))
    '     RegWrite("apiRequists", FormatJson(noOfCalls + 1))
    '     print "Again Api Called: " noOfCalls.toStr()
    '     if m.checkOnItemClicked = true
    '         fetchVideos()
    '         m.checkOnItemClicked = false
    '     else
    '         fetchMoreVideos()
    '     end if
    ' else if ParseJson(RegRead("saveDataDays")) <= 30 and ParseJson(RegRead("apiRequists")) >= 300
    '     print "package Expire try Next month"
    '     showAlertDialog()
    ' else if ParseJson(RegRead("saveDataDays")) = 30
    '     RegWrite("apiRequists", FormatJson(1))
    ' else
    '     print "pakge Expire"
    '     showAlertDialog()
    'end if
'end sub

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
