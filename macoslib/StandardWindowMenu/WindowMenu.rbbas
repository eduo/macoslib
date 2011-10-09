#tag Class
Protected Class WindowMenu
Inherits MenuItem
	#tag Event
		Sub EnableMenu()
		  static localizedTextSet as Boolean = false
		  if not localizedTextSet then
		    self.Text = LocalizedText
		    localizedTextSet = true
		  end if
		  
		  raiseEvent EnableMenu
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		 Shared Sub Initialize()
		  #if targetCocoa
		    dim p as Ptr = MainMenu
		    if p = nil then
		      return
		    end if
		    
		    soft declare function itemWithTitle lib CocoaLib selector "itemWithTitle:" (id as Ptr, aString as CFStringRef) as Ptr
		    soft declare function submenu lib CocoaLib selector "submenu" (id as Ptr) as Ptr
		    soft declare sub setWindowsMenu lib CocoaLib selector "setWindowsMenu:" (id as Ptr, aMenu as Ptr)
		    
		    
		    dim menuText as String = "Window"
		    //it's possible that it might be set to another value, like "Fenster", in the IDE.  So we look up the window menu and
		    //read the text, just in case.
		    dim appMenuBar as MenuBar = App.MenuBar
		    if appMenuBar <> nil then
		      for i as Integer = 0 to appMenuBar.Count - 1
		        dim m as MenuItem = appMenuBar.Item(i)
		        if m isA WindowMenu then
		          menuText = m.Text
		          exit
		        end if
		      next
		    end if
		    
		    dim windMenuItem as Ptr = itemWithTitle(p, menuText)
		    dim windMenu as Ptr = submenu(windMenuItem)
		    setWindowsMenu NSApp, windMenu
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function LocalizedText() As String
		  #if targetMacOS
		    soft declare function CreateStandardWindowMenu Lib CarbonLib  (inOptions as Integer, ByRef outMenu as Integer) as Integer
		    
		    dim theMenu as Integer
		    dim OSError as Integer = CreateStandardWindowMenu(0, theMenu)
		    if OSError <> 0 or theMenu = 0 then
		      return ""
		    end if
		    
		    soft declare function CopyMenuTitleAsCFString Lib CarbonLib (inMenu as Integer, ByRef outString as CFStringRef) as Integer
		    dim menuItemText as CFStringRef
		    OSError = CopyMenuTitleAsCFString(theMenu, menuItemText)
		    
		    soft declare sub CFRelease Lib CarbonLib (cf as Integer)
		    CFRelease theMenu
		    theMenu = 0
		    
		    return menuItemText
		  #endif
		  
		exception fnf as FunctionNotFoundException
		  //this would be very surprising...
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function MainMenu() As Ptr
		  #if targetCocoa
		    soft declare function mainMenu lib CocoaLib selector "mainMenu" (id as Ptr) as Ptr
		    
		    return mainMenu(NSApp)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function NSApp() As Ptr
		  #if targetCocoa
		    soft declare function NSClassFromString lib CocoaLib (aClassName as CFStringRef) as Ptr
		    soft declare function sharedApplication lib CocoaLib selector "sharedApplication" (class_id as Ptr) as Ptr
		    
		    return sharedApplication(NSClassFromString("NSApplication"))
		  #endif
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event EnableMenu()
	#tag EndHook


	#tag Note, Name = Read Me
		This version of the Mac OS standard window menu supports Cocoa only.  Carbon support might be added.
		
		WindowMenu.Initialize should be called in App.Open.  There wasn't a good way to make the classes self-initializing.
		The menu and its items should be localized to reflect the system language settings.  If you find this not to be the case, please
		file a bug report at http://code.google.com/p/macoslib/.
		
		The window menu is actually assembled in a MenuBar editor; this allows you to customize it by adding other menu items.  The 
		Mac OS Human Interface Guidelines provide direction on appropriate uses for the window menu.
	#tag EndNote


	#tag ViewBehavior
		#tag ViewProperty
			Name="AutoEnable"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="MenuItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Checked"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="MenuItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CommandKey"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="MenuItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="MenuItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Icon"
			Group="Behavior"
			InitialValue="0"
			Type="Picture"
			InheritedFrom="MenuItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeyboardShortcut"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="MenuItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Text"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="MenuItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="MenuItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="_mIndex"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="MenuItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="_mName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="MenuItem"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass