sub init()
   print "In Init of SupportScreen"
   RegWrite("supportScreen", "true")
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
