SuperStrict
SetGraphicsDriver GLMax2DDriver()
Graphics 640, 480, 0

Const m:Int = 126
Const damping:Float = 1.3
Const waveForce:Float = 100.0
Const factor:Float = 2.0
Local size:Float = 5

Local Current:Float[m]
Local previous:Float[m]
Local result:Float[m]

While Not KeyHit(KEY_ESCAPE)
	Cls

	If KeyHit(KEY_SPACE)
		Local pos:Int = Rnd (4, m - 4)
		Current[pos - 3] = waveForce
		Current[pos - 2] = waveForce
		Current[pos - 1] = waveForce
		Current[pos + 3] = waveForce
		Current[pos + 2] = waveForce
		Current[pos + 1] = waveForce
		Current[pos] = waveForce
	EndIf
	
	For Local x:Int = 1 To m - 2
	
		result[x]:+(Current[x - 1] + Current[x + 1] - previous[x] * 3) / 4
		result[x]:*damping

		SetColor 5 * Abs(previous[x]), 100, 100
		DrawRect(x * size, 300, size * 2, - 50 - Current[x] * factor)
	Next

	For Local x:Int = 1 To m - 1
		previous[x] = Current[x]
		Current[x] = result[x]
	Next

'	Strange number occurs with this method :
'	previous = current[..]
'	current = result[..]

	Flip
'	Delay 100
Wend



