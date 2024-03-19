sub init()
    m.top.functionName = "getContent"
end sub

sub getContent()
    data = RegRead("defaltPreferences")
    print "date: "; data
    if data <> invalid
        json = ParseJson(data)
        print json
        rootChildrenChannels = []
        row = {}
        row.children = []
        rowItem =0
        for each item in json
            'for i = 0 to checkListArray.Count() - 1
                itemChannel = {}
                'item = checkListArray[i] 
                if item.checked=true                    
                    itemChannel.name = item.title    
                    row.children.Push(itemChannel)   
                end if
            'end for
            rootChildrenChannels.Push(row)
            if rowItem = json.Count()-1                 
                rootChildrenChannels.Push(row)          
                row = {}
                row.children = []
                rowItem = -1
            end if
            rowItem++
        end for
        'rootChildrenChannels.Push(row)
        contentNodeChannel = CreateObject("roSGNode", "ContentNode")
        contentNodeChannel.Update({
            children: rootChildrenChannels
        }, true)
        m.top.content = contentNodeChannel
        m.top.error = "ok"
    else
        m.top.error = "Something went wrong, please try again later"
    end if
end sub

function RegRead(key, section = invalid)
    if section = invalid section = "Default"
    sec = CreateObject("roRegistrySection", section)
    if sec.Exists(key)
        return sec.Read(key)
    else
        m.preferencesExists = false
        return invalid
    end if
    return invalid
end function