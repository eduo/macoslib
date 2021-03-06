#tag Class
Class CFType
	#tag Method, Flags = &h21
		Private Sub AdoptNoVerify(ref as Ptr, hasOwnership as Boolean)
		  // This method must remain private so that only NewObject may call it,
		  // in order to create a direct CFType object (not subclassed) that doesn't
		  // call VerifyType.
		  // No outside function or subclass should be able to skip the verification,
		  // so don't mess with this.
		  
		  if not hasOwnership and ref <> nil then
		    Retain (ref)
		  end if
		  
		  me.mRef = ref
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  // This is private to make sure no one creates an empty CF... instance
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ref as Ptr, hasOwnership as Boolean)
		  // This is the mandatory constructor for all CFType subclasses.
		  //
		  // Use it when you have declared a CF function from the Carbon framework
		  // (CarbonCore) and retrieved any CF... type. Pass the retrieved CF object
		  // as the 'ref' parameter.
		  //
		  // If the object ref was retrieved by a CF...Copy... or CF...Create... function,
		  // pass 'true' to the 'hasOwnership' parameter. Otherwise, pass 'false'.
		  //
		  // The 'hasOwnership' parameter tells this object whether to balance the
		  // release call in its destructor with a retain call.
		  
		  
		  
		  self.AdoptNoVerify(VerifyType(ref), hasOwnership)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CreateFromPListFile(file As FolderItem, mutability As Integer) As CFPropertyList
		  // Added by Kem Tekinay.
		  // Convenience method to return a property list from a PList file.
		  // Classes that are CFPropertyList should override this to return their type.
		  
		  #if targetMacOS
		    
		    dim bs as BinaryStream = BinaryStream.Open( file, false )
		    dim s as string = bs.Read( bs.Length )
		    bs = nil
		    
		    dim plist as CFPropertyList = CreateFromPListString( s, mutability )
		    return plist
		    
		  #else
		    
		    #pragma unused file
		    #pragma unused mutability
		    
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CreateFromPListString(plistString as String, mutability As Integer) As CFPropertyList
		  // Added by Kem Tekinay.
		  // Convenience method to return a property list from a PList string.
		  // Classes that are CFPropertyList should override this to return their type.
		  
		  #if targetMacOS
		    
		    dim errMsg as string
		    dim plist as CFPropertyList = NewCFPropertyList( plistString, mutability, errMsg )
		    
		    return  plist
		    
		  #else
		    
		    #pragma unused plistString
		    #pragma unused mutability
		    
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  Release me.mRef
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Equals(theObj as CFType) As Boolean
		  if theObj is nil then
		    return (me.mRef = nil)
		  end if
		  
		  #if TargetMacOS
		    soft declare function CFEqual lib CarbonLib (cf1 as Ptr, cf2 as Ptr) as Boolean
		    
		    return CFEqual(me.mRef, theObj.Reference)
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function FromHandle(handle as Integer) As CFType
		  // This is an alternative constructor for "foreign" CFType objects.
		  //
		  // It can be used to access existing CFType objects, e.g. those from MBS plugins,
		  // by passing their Handle property to this constructor
		  
		  return NewObject(Ptr(handle), not hasOwnership)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Hash() As UInt32
		  #if TargetMacOS
		    soft declare function CFHash lib CarbonLib (cf as Ptr) as UInt32
		    
		    if me.mRef <> nil then
		      return CFHash(me.mRef)
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Deprecated = "=nil" )  Function IsNULL() As Boolean
		  return (me = nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function NewObject(ref as Ptr, hasOwnership as Boolean, mutability as Integer = kCFPropertyListImmutable) As CFType
		  // This function never returns nil on Mac OS X (but always nil on other platforms)
		  //
		  // hasOwnership: pass true if ref comes from a OS's CF... call and has just been retained. The constructor will release it then.
		  
		  // Note: This function is effectively the same as using "new CF...(ref)" if the type is known in advance.
		  //  This means that this function is to be used where the type of "ref" is not known, otherwise the
		  //  explicit class constructors are to be preferred as they're faster.
		  
		  #if TargetMacOS
		    
		    if ref = nil then
		      return new CFType() // this gives a CFType object whose "IsNULL()" function returns true
		    end if
		    
		    if not hasOwnership then
		      Retain(ref)
		      hasOwnership = true
		    end if
		    
		    dim theTypeID as UInt32 = CFGetTypeID(ref)
		    
		    select case theTypeID
		      
		    case CFArray.ClassID
		      if mutability <> kCFPropertyListImmutable then
		        return new CFMutableArray(ref, hasOwnership)
		      else
		        return new CFArray(ref, hasOwnership)
		      end
		      
		    case CFBoolean.ClassID
		      static b as CFType = CFBoolean.GetTrue //needed to get the compiler to see the private mRef property
		      if ref = b.mRef then
		        return CFBoolean.GetTrue
		      else
		        return CFBoolean.GetFalse
		      end if
		      
		    case CFBundle.ClassID
		      dim b as new CFBundle(ref, hasOwnership)
		      return b
		      
		    case CFData.ClassID
		      if mutability = kCFPropertyListMutableContainersAndLeaves then
		        return new CFMutableData(ref, hasOwnership)
		      else
		        return new CFData(ref, hasOwnership)
		      end
		      
		    case CFDate.ClassID
		      dim b as new CFDate(ref, hasOwnership)
		      return b
		      
		    case CFDictionary.ClassID
		      if mutability <> kCFPropertyListImmutable then
		        return new CFMutableDictionary(ref, hasOwnership)
		      else
		        return new CFDictionary(ref, hasOwnership)
		      end
		      
		    case CFNumber.ClassID
		      dim b as new CFNumber(ref, hasOwnership)
		      return b
		      
		    case CFString.ClassID
		      if mutability = kCFPropertyListMutableContainersAndLeaves then
		        return new CFMutableString(ref, hasOwnership)
		      else
		        return new CFString(ref, hasOwnership)
		      end
		      
		    case CFURL.ClassID
		      dim url as new CFURL(ref, hasOwnership)
		      return url
		      
		    case CFNull.ClassID
		      dim null as new CFNull(ref, hasOwnership)
		      return null
		      
		    case CFUUID.ClassID
		      return  new CFUUID(ref, hasOwnership)
		      
		    else
		      // It's an unknown CF type. Let's return a generic CFType so that at least
		      // this class' operations (Show, Equals, etc.) can be applied to it.
		      
		      dim cft as new CFType()
		      cft.AdoptNoVerify(ref, hasOwnership) // this avoids the type verification
		      return cft
		      
		      #if false
		        // this is not needed but remains in here in case someone wants it back:
		        #if DebugBuild
		          soft declare function CFCopyTypeIDDescription lib CarbonLib (cfid as UInt32) as CFStringRef
		          soft declare function CFCopyDescription lib CarbonLib (cf as Ptr) as CFStringRef
		          soft declare sub CFShow lib CarbonLib ( obj as Ptr )
		          
		          dim cfs as CFStringRef = CFCopyTypeIDDescription ( theTypeID )
		          dim cfd as CFStringRef = CFCopyDescription ( p )
		          System.DebugLog( "type id = " + str(theTypeID) )
		          System.DebugLog( cfs )
		          System.DebugLog( cfd )
		          CFShow(p)
		        #endif
		      #endif
		      
		    end select
		    
		    // we should never arrive here
		    
		  #else
		    
		    #pragma unused ref
		    #pragma unused hasOwnership
		    #pragma unused mutability
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(t as CFType) As Integer
		  // Tells whether the two CF objects are the same CF instance but not necessarily the
		  //   same value (for equality check, use the Equals() function)
		  
		  //A CFType object with mRef = nil is treated as a nil object.
		  
		  
		  if t is nil then
		    if me.Reference = nil then
		      return 0
		    else
		      return 1
		    end if
		    
		  else
		    return Integer(me.Reference) - Integer(t.Reference)
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Convert() As Ptr
		  // This is a convenience function to get the reference to the OS object,
		  // for passing to CoreFoundation functions.
		  
		  return me.Reference // Call this function (not return mRef directly) because it might be overridden
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RefCount() As Integer
		  return RefCount(me.mRef)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RefCount(ref as Ptr) As Integer
		  #if TargetMacOS
		    soft declare function CFGetRetainCount lib CarbonLib (cf as Ptr) as Integer
		    if ref <> nil then
		      return CFGetRetainCount(ref)
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Reference() As Ptr
		  return me.mRef
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Release()
		  Release me.mRef
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Release(ref as Ptr)
		  #if TargetMacOS
		    soft declare sub CFRelease lib CarbonLib (cf as Ptr)
		    
		    '#if DebugBuild
		    'dim cnt as Integer = RefCount(ref)
		    'System.DebugLog "release "+Hex(Integer(ref))+" ("+Str(cnt)+"->"+Str(cnt-1)+")"
		    '#endif
		    
		    if ref <> nil then
		      CFRelease ref
		    end if
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Retain()
		  Retain me.mRef
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Retain(ref as Ptr)
		  #if TargetMacOS
		    soft declare function CFRetain lib CarbonLib (cf as Ptr) as Integer
		    
		    '#if DebugBuild
		    'dim cnt as Integer = RefCount(ref)
		    'System.DebugLog "retain  "+Hex(Integer(ref))+" ("+Str(cnt)+"->"+Str(cnt+1)+")"
		    '#endif
		    
		    if ref <> nil then
		      call CFRetain(ref)
		    end if
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Show()
		  #if TargetMacOS
		    soft declare sub CFShow lib CarbonLib (obj as Ptr)
		    
		    if me.mRef <> nil then
		      CFShow me.mRef
		    end if
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function TypeDescription(id as UInt32) As String
		  #if TargetMacOS
		    declare function CFCopyTypeIDDescription lib CarbonLib (id as UInt32) as CFStringRef
		    
		    if id <> 0 then
		      return CFCopyTypeIDDescription(id)
		    else
		      return ""
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TypeID() As UInt32
		  #if TargetMacOS
		    if me.mRef <> nil then
		      return CFGetTypeID(self.mRef)
		    else
		      return 0
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VariantValue() As Variant
		  // This method is intended for use in dumping the contents of a CFDictionary.
		  // Objects that can reasonably be converted to a REALbasic datatype
		  // should do so in their VariantValue event handler.
		  // Other objects (like CFBundle) that have no analogue should do nothing, or simply return nil.
		  
		  return raiseEvent VariantValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function VerifyType(ref as Ptr) As Ptr
		  #if targetMacOS
		    if ref = nil or (RaiseEvent ClassID()) = CFGetTypeID(ref) then
		      return ref
		    else
		      declare function CFCopyTypeIDDescription lib CarbonLib (id as Integer) as CFStringRef
		      dim e as new TypeMismatchException
		      e.Message = "CFTypeRef &h" + Hex(ref) + " has ID " + CFCopyTypeIDDescription(CFGetTypeID(ref)) + " but " + CFCopyTypeIDDescription(RaiseEvent ClassID()) + " was expected."
		      raise e
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function WriteToFile(file as FolderItem, asXML as Boolean = true) As Boolean
		  // Added by Kem Tekinay.
		  //This method is declared by CFPropertyList; CFType subclasses that implement CFPropertyList
		  //invoke this method.
		  
		  #if targetMacOS
		    dim plist as CFPropertyList = CFPropertyList( me )
		    dim url as new CFURL( file )
		    dim stream as new CFWriteStream( url, false ) //Replace file
		    dim errMsg as string
		    dim OK as Boolean
		    
		    dim format as Integer
		    if asXML then
		      format = CoreFoundation.kCFPropertyListXMLFormat_v1_0
		    else
		      format = CoreFoundation.kCFPropertyListBinaryFormat_v1_0
		    end if
		    
		    if stream.Open then
		      try
		        OK = plist.Write( stream, format, errMsg )
		      finally
		        stream.Close
		      end try
		    end if
		    
		    
		    
		    return  OK
		  #endif
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ClassID() As UInt32
	#tag EndHook

	#tag Hook, Flags = &h0
		Event VariantValue() As Variant
	#tag EndHook


	#tag Note, Name = Memory Management
		CFType follows the same memory management scheme used by CFStringRef. A CFType object is
		created with whatever reference count the CFTypeRef has, and the CFTypeRef is always released
		by the destructor.
		
		This means that CFType objects created from a Core Foundation Get* function may need to have
		their reference counts incremented by hand -- This is what the "hasOwnership" parameter is for - if you
		only use the Adopt and the CFType.Constructor(Ptr,Boolean) methods, you should not have to worry
		about reference counting.
	#tag EndNote


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  return me.RefCount
			End Get
		#tag EndGetter
		Private debugRefCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			This is mainly useful to see the value in the debugger.
			Warning: Do not use this in your code for other purposes as the value might change
			even between different Mac OS versions!
		#tag EndNote
		#tag Getter
			Get
			  #if TargetMacOS
			    soft declare function CFCopyDescription lib CarbonLib (cf as Ptr) as Ptr
			    // Caution: If this would return a CFStringRef, we'd have to Retain its value!
			    // Instead, "new CFString()" takes care of that below
			    
			    if not ( self = nil ) then
			      return new CFString(CFCopyDescription(me.mRef), true)
			    end if
			  #endif
			End Get
		#tag EndGetter
		Description As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mRef As Ptr
	#tag EndProperty


	#tag Constant, Name = ClassName, Type = String, Dynamic = False, Default = \"CFType", Scope = Private
	#tag EndConstant

	#tag Constant, Name = hasOwnership, Type = Boolean, Dynamic = False, Default = \"true", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Description"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
