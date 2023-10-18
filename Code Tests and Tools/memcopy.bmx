SuperStrict

Local T0%, T1%, T2%, T3%
Local Bank1:TBank = CreateBank(40000*4)
Local Bank2:TBank = CreateBank(40000*4)
Local Pixels1:Float[164,100]	
Local Pixels2:Float[164,100]
Local Ptr1:Byte Ptr, Ptr2:Byte Ptr
Local Loop%, Loops% = 100


Ptr1 = MemAlloc(40000*4) 
Ptr2 = MemAlloc(40000*4)

T0 = MilliSecs()

	For Loop = 1 To Loops
		CopyBank(Bank1, 0, Bank2, 0, 40000*4)
	Next

T1 = MilliSecs()
	
	Local Loop2%
	Local loop3%
	
	For Loop = 1 To Loops
		For Loop2 = 0 Until 163
			For Loop3 = 0 Until 99
				Pixels1[Loop2,Loop3] = Pixels2[Loop2,Loop3]
			Next
		Next
	Next
	
T2 = MilliSecs()

	For Loop = 1 To Loops
		MemCopy(Pixels1, Pixels2, SizeOf Pixels1)
	Next
	
T3 = MilliSecs()

Print "CopyBank = " + (T1-T0)
Print "Copy Array = " + (T2-T1)
Print "MemCopy = " + (T3-T2)
