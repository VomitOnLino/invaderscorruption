Local food:String[] = ["Milk","Raisins","Hamburger","Spam"]


Type TItem
	Field Name : String
	Function Create:TItem(I:Int)
		Local r : TItem = New TItem
		r.Name = "Item "+I
		Return r
	End Function
End Type

'Local foodlist:TList = CreateList()


Local foodlist:TList = CreateList()

For Local i:Int = 0 Until 4
 Foodlist.Addlast(TItem.Create(i))
Next


Rem
foodlist.addlast("Milk")
foodlist.addlast("Raisins")
foodlist.addlast("Hamburger")
foodlist.addlast("Spam")

End Rem

now# = MilliSecs()
	For loop = 10 To 100000
		For x = 0 To Len(food)-1
			'Print food[x]
		Next
	Next
elapsed# = MilliSecs()-now
Print "Array Elapsed:"+elapsed


now# = MilliSecs()
	For loop = 10 To 100000
		For Item:Titem = EachIn foodlist
			Item.Name="Fred"
		Next

	Next
elapsed# = MilliSecs()-now
Print "List Elapsed:"+elapsed


now# = MilliSecs()
	For loop = 10 To 100000
		Local link:TLink= FoodList.FirstLink()
		While link
		  Local eitem:TItem=TItem(link._value)
		  If link._succ._value<>link._succ 
			link=link._succ
			eitem.Name="Fred"
		  Else
		    link=Null
		  End If		
		Wend
	Next
elapsed# = MilliSecs()-now
Print "List Optimized Elapsed:"+elapsed
