sub CheckSubscriptionAndStartPlayback()
    RunSubscriptionFlow()
    print "CheckSubscriptionAndStartPlayback: run"
end sub

sub RunSubscriptionFlow()

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
                CategoriesScreenData()
                return
            else 
                subcriptionCheckDialog()
            end if

        end for
    else 
        subcriptionCheckDialog()
    end if
end sub
