sub init()
    m.top.functionName = "rateUs"
end sub

sub rateUs()
    m.app = CreateObject("roAppManager")
    m.app1 = CreateObject("roAppInfo")
    m.id =m.app1.getID()
    print " channel id : "m.id
    'createObject("roAppManager").showChannelStoreSpringboard("701547") 
    createObject("roAppManager").showChannelStoreSpringboard(m.id) 'jb channel publish hoga tou iski channelId likhni ha 
end sub


