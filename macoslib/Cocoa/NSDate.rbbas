#tag ClassClass NSDateInherits NSObject	#tag Method, Flags = &h0		 Shared Function Now() As NSDate		  #if targetCocoa		    soft declare function date lib CocoaLib selector "date" (class_id as Ptr) as Ptr		    		    return new NSDate(date(Cocoa.NSClassFromString("NSDate")))		  #endif		End Function	#tag EndMethod	#tag ViewBehavior		#tag ViewProperty			Name="Description"			Group="Behavior"			Type="String"			InheritedFrom="NSObject"		#tag EndViewProperty		#tag ViewProperty			Name="Index"			Visible=true			Group="ID"			InitialValue="-2147483648"			InheritedFrom="Object"		#tag EndViewProperty		#tag ViewProperty			Name="Left"			Visible=true			Group="Position"			InitialValue="0"			InheritedFrom="Object"		#tag EndViewProperty		#tag ViewProperty			Name="Name"			Visible=true			Group="ID"			InheritedFrom="Object"		#tag EndViewProperty		#tag ViewProperty			Name="Super"			Visible=true			Group="ID"			InheritedFrom="Object"		#tag EndViewProperty		#tag ViewProperty			Name="Top"			Visible=true			Group="Position"			InitialValue="0"			InheritedFrom="Object"		#tag EndViewProperty	#tag EndViewBehaviorEnd Class#tag EndClass