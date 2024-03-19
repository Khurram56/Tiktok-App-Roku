sub init()

   m.title = m.top.findNode("tittle")
   m.poster = m.top.findNode("poster")
   m.backBtn = m.top.findNode("backBtn")
   m.top.setFocus(true)

   print "In Init of SupportScreen"
   'RegWrite("supportScreen", "true")
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

function RegDelete(key, section = invalid)
   if section = invalid section = "Default"
   sec = CreateObject("roRegistrySection", section)
   sec.Delete(key)
   sec.Flush()
end function

function RegWrite(key, val, section = invalid)
   if section = invalid section = "Default"
   sec = CreateObject("roRegistrySection", section)
   sec.Write(key, val)
   sec.Flush() 'commit it
end function

function onKeyEvent(key as string, press as boolean) as boolean
   handled = false
   if press
       if key = "down"
           m.backBtn.setFocus(true)
       end if
   end if
   return handled
end function