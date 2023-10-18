'Maze Generator Library
Type TMaze

	'drawing coord for Maze
	Field MazeX:Int
	Field MazeY:Int
	
	'Cell Quantity 
	Field CellQX:Int
	Field CellQY:Int
	
	'Array of Mace CEllS
	Field Cell:TMazeCell[,]
	
	Field StartCell:TMazeCell
	Field EndCell:TMazeCell
	
	Field Cellsize:Int
	
	Function CreateMaze:TMaze(cellQX:Int, cellQY:Int, cellsize:Int)
		Local m:TMaze = New TMaze
		
		m.CellQX = cellQX
		m.CellQY = CellQY
		
		m.Cellsize = cellsize
		
		m.Cell = New TMazeCell[cellQX, CEllQY]
		
		Local cellID:Int = 0
		For Local cx:Int = 0 To cellqx - 1
			For Local cy:Int = 0 To cellqy - 1
				cellID:+1
				m.Cell[cx, cy] = TMazeCell.CreateBaseCell(cx, cy, cellId, m.CellSize)
			Next
		Next
		
		Return m
	End Function
	
	Method setStartCell(cell:TMazeCell)
		Self.StartCell = cell
	End Method
	
	Method setEndCell(cell:TMazeCell)
		Self.EndCell = cell
	End Method
	
	Method Generate:TPixmap(R:Int,G:Int,B:Int,A:Int,IsShield:Byte=False,IsChaos:Byte=False)
		
		Local MazePixmap:TPixmap=CreatePixmap(CellQX*2+6,CellQY*2+6,PF_RGBA8888)
		
		ClearPixels (MazePixmap)
		
		If Not IsShield
			If Not IsChaos
				For Local x:Int = 1 To CellQX*2-2
					For Local y:Int = 1 To CellQY*2-2
						
						WritePixel MazePixMap,x+3,y+3,ToRGBA(R,G,B,32)
						
						'cell[qx, qy].draw(3,MazePixMap,R,G,B,195)
					Next
				Next
				For Local qx:Int = 1 To CellQX - 2
					For Local qy:Int = 1 To CellQY - 2
						
						cell[qx, qy].draw(3,MazePixMap,R,G,B,A)
						
					Next
				Next
			Else
				Local BrightnessModulate:Int
				'Chaos Maze
				For Local x:Int = 1 To CellQX*2-2
					For Local y:Int = 1 To CellQY*2-2
						If x<7 Or y<7 Or x>CellQx*2-9 Or y>CellQY*2-9
							If x<3 Or y<3 Or x>CellQx*2-5 Or y>CellQY*2-5
								If Rand(0,7)=2 WritePixel MazePixMap,x+3,y+3,ToRGBA(R,G,B,24)
							Else
								If Rand(0,3)=2 WritePixel MazePixMap,x+3,y+3,ToRGBA(R,G,B,26)
							End If
						Else
							WritePixel MazePixMap,x+3,y+3,ToRGBA(R,G,B,0)
						End If
						'cell[qx, qy].draw(3,MazePixMap,R,G,B,195)
					Next
				Next
				For Local qx:Int = 1 To CellQX - 2
					For Local qy:Int = 1 To CellQY - 2
						BrightnessModulate=(Abs((CellQX)/2-qx)+Abs((CellQY)/2-qy))*11
						'Print BrightnessModulate
						If qx<5 Or qy<5 Or qx>CellQx-7 Or qy>CellQY-7
							If qx<2 Or qy<2 Or qx>CellQx-3 Or qy>CellQY-3
								If Rand(0,7)=2 cell[qx, qy].draw(3,MazePixMap,R,G,B,A-BrightnessModulate)
							Else
								If Rand(0,2)=2 cell[qx, qy].draw(3,MazePixMap,R,G,B,A-BrightnessModulate)
							End If
						Else
							cell[qx, qy].draw(3,MazePixMap,R,G,B,A-BrightnessModulate)
						End If
						
						
					Next
				Next

			End If
			
		Else
			For Local qx:Int = 1 To CellQX - 2
				For Local qy:Int = 1 To CellQY - 2
					cell[qx, qy].draw(3,MazePixMap,R,G,B,255)
				Next
			Next
		End If
		
		Return MazePixmap
	
	End Method
	
	Function ToRGBA%(r%,g%,b%,a%) Private

		Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
End Type

Type TMazeGen Abstract

	Function ClearVisitedCells(maze:TMaze)
		If maze.cellqx > 0 And maze.cellqy > 0
			For Local X:Byte = 0 To maze.CellQX - 1
				For Local Y:Byte = 0 To maze.CEllQY - 1
					maze.Cell[X, Y].visited = 0
				Next
			Next
		EndIf

	End Function
	
	Function CarveCell(FromCell:TMazeCell, ToCell:TMazeCell)
		
		'carving left
		If FromCell.CordX = ToCell.CordX - 1
			Tocell.leftwall = 0
			FromCell.rightwall = 0
		EndIf
		
		'carving right
		If FromCEll.CordX = ToCell.CordX + 1
			ToCell.rightwall = 0
			FromCell.leftwall = 0
		End If
		
		'carving top
		If FromCell.CordY = ToCell.CordY - 1
			ToCell.topwall = 0
			FromCell.bottomwall = 0
		End If
		
		'carving bottom
		If FromCell.CordY = ToCell.CordY + 1
			ToCEll.bottomwall = 0
			FromCell.topwall = 0
		End If
	
	End Function
	
End Type

Type TMazeCell

	Field CellId:Int
	Field CordX:Int 'x position in array
	Field CordY:Int 'y position in array

	Field drawx:Int
	Field drawy:Int
	
	Field drawxrelative:Int
	Field drawyrelative:Int

	Field visited:Byte = 0
	Field leftwall:Byte = 1
	Field rightwall:Byte = 1
	Field topwall:Byte = 1
	Field bottomwall:Byte = 1
	
	Field CellSize:Int
	
	Field CellType:Byte
	
	Field CellStatus:Byte = 0
	
	Const CELL_START:Byte = 1
	Const CELL_END:Byte = 2
	Const CELL_REG:Byte = 3
	
	Field solution:Int = 0 'if solution is 0 it hasnt been checked, if its -1, its not part of the solution and if its 1, its part of it
	Field solutionpathID:Int = 0 'the number of cell in the solution path(0,1,2,3 etc)
	Field cellpathid:Int 'id given when cell is visited, this is for path verification
	
	Field img:TImage
	
	Method New()
		SetWalls(1, 1, 1, 1)
	End Method
	
	Function CreateBaseCell:TMazeCell(CordX:Int, CordY:Int, CellID:Int, CellSize:Int)
		Local Cell:TMazeCell = New TMazeCell
		Cell.CordX = CordX
		Cell.CordY = CordY
		Cell.CellId = CellID
		Cell.drawxrelative = CordX * cellSize
		Cell.drawyrelative = CordY * cellsize
		cell.CellSize = cellsize
		Return Cell
	End Function
	
	Method SetCellType(CellType:Byte) 
		Self.CellType = CellType
	End Method
	
	Method SetWalls(leftwall:Byte, topwall:Byte, rightwall:Byte, bottomwall:Byte)
		Self.leftwall = leftwall
		Self.topwall = topwall
		Self.rightwall = rightwall
		Self.bottomwall = bottomwall
	End Method
	
	Method Draw(Offset:Int,PixMap:TPixmap,R:Int,G:Int,B:Int,A:Int)
	
		If leftwall = 1 Then WritePixel PixMap,drawx + drawxrelative+Offset, drawy + drawyrelative+Offset,ToRGBA(R,G,B,A)
		If topwall = 1 Then WritePixel PixMap,drawx + drawxrelative+Offset, drawy + drawyrelative+Offset,ToRGBA(R,G,B,A)
		If rightwall = 1 Then WritePixel PixMap,drawx + drawxrelative + 1+Offset, drawy + drawyrelative+Offset,ToRGBA(R,G,B,A)
		If bottomwall = 1 Then WritePixel PixMap,drawx + drawxrelative+Offset, drawy + drawyrelative + 1+Offset,ToRGBA(R,G,B,A)
	
	End Method
	
	Function ToRGBA%(r%,g%,b%,a%) Private

		Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
End Type

Type TMazeGenerator Extends TMazeGen Abstract
	
	Const PRIMCELL_FRONTIER:Byte = 1
	Const PRIMCELL_IN:Byte = 2
	Const PRIMCELL_OUT:Byte = 3

	Function createMaze:TMaze(cellQX:Int, CellQY:Int)
	
		Local maze:TMaze = TMaze.CreateMaze(cellQX, cellQY, 2)
		
		'Creates a list to store neightbors 
		Local FrontierCells:TList = CreateList()
		Local InCells:TList = CreateList()
		Local OutCells:TList = CreateList()

		'sets all cells to OUT.
		For Local qx:Int = 0 To CellQX - 1
			For Local qy:Int = 0 To CEllQY - 1
				maze.Cell[qx, qy].cellstatus = PRIMCELL_OUT
				ListAddLast(OutCells, maze.Cell[qx, qy])
			Next
		Next
	
		maze.StartCell = maze.Cell[Rand(0,CellQX-1), Rand(0,CellQY-1)]
		maze.startcell.SetCellType(TMazeCell.CELL_START)
		maze.EndCell = maze.Cell[Rand(0,CellQX-1), Rand(0,CellQY-1)]
		maze.endcell.setCellType(TMazeCell.CELL_END)
			
		Local pqx:Int = 1
		Local pqy:Int = 1
		
		Local fcell:TMazeCell = maze.Cell[pqx, pqy]
		Local ncell:TMazeCell
		
	 	Repeat

			'get new cell 
			pqx = fcell.CordX
			pqy = fcell.CordY
			
			'make cell IN.
			If maze.Cell[pqx, pqy].CellStatus <> PRIMCELL_IN
				SetPrimCell(maze.Cell[pqx, pqy], PRIMCELL_IN, incells, outcells, frontiercells)
			End If
			

			SetNeighborsToFrontier(maze, pqx, pqy, incells, outcells, frontiercells)
			
			fcell:TMazeCell = TMazeCell(PickAndRemoveRndObj(FrontierCells))
			
			nCell:TMazeCell = TMazeCell(PickAndRemoveRndObj(GetNeighborsIn(maze:TMaze, fcell)))
			
			SetPrimCell(fcell, PRIMCELL_IN, incells, outcells, frontiercells)
			
			CarveCell(ncell, fcell)
			
		Until FrontierCells.count() = 0
		
		ClearVisitedCells(maze)
		
		Return maze
		
	EndFunction
	
	Function SetPrimCell(Cell:TMazeCell, CellStatus:Byte, incells:TList, outcells:TList, FrontierCells:TList)
	
		Select CellStatus
			
			Case PRIMCELL_FRONTIER
			
				If cell.CellStatus = PRIMCELL_IN
					ListRemove(inCells, cell)
				End If
				If CELL.CellStatus = PRIMCELL_OUT
					ListRemove(OutCells, cell)
				End If
				ListAddLast(FrontierCells, cell)
				
			Case PRIMCELL_IN
			
				If CELL.CellStatus = PRIMCELL_OUT
					ListRemove(OutCells, cell)
				End If
				If CELL.CellStatus = PRIMCELL_FRONTIER
					ListRemove(FrontierCells, cell)
				End If
				ListAddLast(InCells, cell)
				
			Case PRIMCELL_OUT
				If CELL.CellStatus = PRIMCELL_IN
					ListRemove(InCells, cell)
				End If
				If CELL.CellStatus = PRIMCELL_FRONTIER
					ListRemove(FrontierCells, cell)
				End If
				ListAddLast(OutCells, cell)
				
		End Select
		
		cell.CellStatus = CellStatus
	
	EndFunction
	
	Function SetNeighborsToFrontier(maze:TMaze, pqx:Int, pqy:Int, inCells:TList, outcells:TList, frontierCells:TList)
	
		'if neighbor aint IN then set them to frontier
		'left neighbor
		If (pqx - 1) >= 0
			If maze.Cell[pqx - 1, pqy].CellStatus = PRIMCELL_OUT
				
				SetPrimCell(maze.Cell[pqx - 1, pqy], PRIMCELL_FRONTIER, incells, outcells, frontiercells)
			
			EndIf
		End If
		
		'right neighbor
		If (pqx + 1) <= maze.CellQX - 1
			If maze.Cell[pqx + 1, pqy].CellStatus = PRIMCELL_OUT
				
				SetPrimCell(maze.Cell[pqx + 1, pqy], PRIMCELL_FRONTIER, incells, outcells, frontiercells)
				
			EndIf
			
		End If
		
		'top neighbor
		If (pqy - 1) >= 0
			If maze.Cell[pqx, pqy - 1].CellStatus = PRIMCELL_OUT
				
				SetPrimCell(maze.Cell[pqx, pqy - 1], PRIMCELL_FRONTIER, incells, outcells, frontiercells)

			EndIf
		End If
		
		'bottom neighbor
		If (pqy + 1) <= Maze.CellQY - 1
			If maze.Cell[pqx, pqy + 1].CellStatus = PRIMCELL_OUT
				
				SetPrimCell(maze.Cell[pqx, pqy + 1], PRIMCELL_FRONTIER, incells, outcells, frontiercells)
				
			EndIf
		EndIf
		
	End Function

	Function GetNeighborsIn:TList(maze:TMaze, baseCell:TMazeCell)
		
		Local cellsIn:TList = CreateList()
		
		'left neighbor
		If (baseCell.CordX - 1) >= 0
			If maze.Cell[baseCell.CordX - 1, baseCell.CordY].CellStatus = PRIMCELL_IN
				ListAddLast(cellsIn, maze.Cell[baseCell.CordX - 1, baseCell.CordY])
			EndIf
		EndIf
		
		'right neighbor
		If (baseCell.CordX + 1) <= maze.CellQX - 1
			If maze.Cell[baseCell.CordX + 1, baseCell.CordY].CellStatus = PRIMCELL_IN
				ListAddLast(cellsIn, maze.Cell[baseCell.CordX + 1, baseCell.CordY])
			EndIf
		EndIf
		
		'top neighbor
		If (baseCell.CordY - 1) >= 0
			If maze.Cell[baseCell.CordX, baseCell.CordY - 1].CellStatus = PRIMCELL_IN
				ListAddLast(cellsIn, maze.Cell[baseCell.CordX, baseCell.CordY - 1])
			EndIf
		EndIf
		
		'bottom neighbor
		If (baseCell.CordY + 1) <= maze.CellQY - 1
			If maze.Cell[baseCell.CordX, baseCell.CordY + 1].CellStatus = PRIMCELL_IN
				ListAddLast(cellsIn, maze.Cell[baseCell.CordX, baseCell.CordY + 1])
			EndIf
		EndIf
		
		Return cellsIn
		
	End Function
	
	Function PickAndRemoveRndObj:Object(list:TList)
		Local Pick:Int = Rand(1, list.count())
		Local cnt:Int = 1
		
		For Local o:Object = EachIn List
			If cnt = Pick
				Local obj:Object = o
				list.Remove(o)
				Return obj
			End If
			cnt:+1
		Next
	End Function
	
End Type