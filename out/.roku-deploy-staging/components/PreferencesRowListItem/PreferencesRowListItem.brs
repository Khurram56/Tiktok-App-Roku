sub OnContentSet() ' invoked when item metadata retrieved
    content = m.top.itemContent
    if content <> invalid 
        m.top.FindNode("title").text = content.name
        print "Thumbnail: " content.name
    end if
end sub