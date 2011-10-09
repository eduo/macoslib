#tag Class
Class NSPathControl
Inherits NSControl
	#tag Event
		Sub Action()
		  #if targetCocoa
		    soft declare function clickedPathComponentCell lib CocoaLib selector "clickedPathComponentCell" (id as Ptr) as Ptr
		    
		    dim p as Ptr = clickedPathComponentCell(me.id)
		    if p <> nil then
		      raiseEvent Action(new NSPathComponentCell(p))
		    else
		      raiseEvent Action(nil)
		    end if
		  #endif
		End Sub
	#tag EndEvent

	#tag Event
		Sub DoubleClick(X As Integer, Y As Integer)
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Function NSClassName() As String
		  return "NSPathControl"
		End Function
	#tag EndEvent


	#tag Hook, Flags = &h0
		Event Action(clickedComponentCell as NSPathComponentCell)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DoubleClick()
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if targetCocoa
			    if me.id <> nil then
			      soft declare function backgroundColor lib CocoaLib selector "backgroundColor" (id as Ptr) as Ptr
			      
			      dim c as new NSColor(backgroundColor(me.id))
			      return c.ColorValue
			    else
			      return &c000000
			    end if
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #if targetCocoa
			    if me.id <> nil then
			      soft declare sub setBackgroundColor lib CocoaLib selector "setBackgroundColor:" (id as Ptr, c as Ptr)
			      
			      dim c as new NSColor(value)
			      setBackgroundColor me.id, c
			    else
			      //
			    end if
			  #endif
			End Set
		#tag EndSetter
		BackgroundColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if targetCocoa
			    if me.id = nil then
			      return 0
			    end if
			    
			    soft declare function pathStyle lib CocoaLib selector "pathStyle" (id as Ptr) as Integer
			    
			    return pathStyle(me.id)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #if targetCocoa
			    if me.id = nil then
			      return
			    end if
			    
			    soft declare sub setPathStyle lib CocoaLib selector "setPathStyle:" (id as Ptr, style as Integer)
			    
			    setPathStyle me.id, value
			  #endif
			End Set
		#tag EndSetter
		PathStyle As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if targetCocoa
			    if me.id <> nil then
			      soft declare function getURL lib CocoaLib selector "URL" (id as Ptr) as Ptr
			      
			      dim p as Ptr = getURL(me.id)
			      if p <> nil then
			        soft declare function absoluteString lib CocoaLib selector "absoluteString" (id as Ptr) as CFStringRef
			        return absoluteString(p)
			      else
			        return ""
			      end if
			    else
			      return ""
			    end if
			  #endif
			  
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #if targetCocoa
			    soft declare sub setURL lib CocoaLib selector "setURL:" (id as Ptr, url as Ptr)
			    
			    soft declare function NSClassFromString lib CocoaLib (aClassName as CFStringRef) as Ptr
			    soft declare function alloc lib CocoaLib selector "alloc" (classRef as Ptr) as Ptr
			    soft declare function initWithString lib CocoaLib selector "initWithString:" (id as Ptr, URLString as CFStringRef) as Ptr
			    
			    dim url_id as Ptr = initWithString(alloc(NSClassFromString("NSURL")), value)
			    
			    setURL me.id, url_id
			    
			    soft declare sub release lib CocoaLib selector "release" (id as Ptr)
			    release url_id
			  #endif
			End Set
		#tag EndSetter
		URL As String
	#tag EndComputedProperty


	#tag Constant, Name = NSPathStyleNavigationBar, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = NSPathStylePopUp, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = NSPathStyleStandard, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AcceptFocus"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptTabs"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="autoresizesSubviews"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="NSControl"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackgroundColor"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EraseBackground"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Group="Initial State"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsFlipped"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="NSControl"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PathStyle"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Standard"
				"1 - Navigation Bar"
				"2 - PopUp"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Group="Position"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="URL"
			Visible=true
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Group="Appearance"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass