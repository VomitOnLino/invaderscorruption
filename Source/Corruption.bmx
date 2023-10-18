'-----------------------------------------------------------------------------
'Author comments and notes 2010-2011 Manuel van Dyck
'-----------------------------------------------------------------------------
Rem
1.2.8
-Fixes Bug In Resolution Enumeration
-Generally Made Resolution Enumeration More Sane
-Improvements To Graphical Seed Diversity
-Small Menu Fixes

1.2.7
-Added difficulty tiering to hi-scores
-Improved joystick input and calibration mechanisms
-Adds Power-up overview to help-screen
-Fixes multiplier not increasing NET MIND scores
-Breaks Compatibility with 1.2.6 Hi-Scores

1.2.6
-Improved Thief Despawn animation
-Fixed tracking of Frenzies for "NOMADIC BONUS"

1.2.5 (The Mac Appstore Version)
-OS X: Now stores configuration files And highscore files in the User/Library folder
-OS X: Fixed settings retention on user-rights accounts
-OS X: Fixed Crash on Lion when altering graphic-settings repeatedly
-OS X: Added 512px application icon
-Cursor size is now retained at resolutions smaller than 1024x768
-Fixes background-effect inconsistencies when switching screen modes
-Fixed menu-sounds playing during server connection
-Fixes lightning-strike effect when corrupting invaders
-Fixes slow motion Not being retained during pause
-Fixes cursor still animating during pause
-Fixes menu, bomb icon And backgrounds becoming misaligned when switching resolutions
-Fixes memory leak when toggling widescreen mode
-Fixes smaller graphical errors For an easter egg
-Improves performance stability And memory usage
-Improves visual effects For corrupted invaders
-Improves visual bloom effects For the player ship And invaders
-Improves visual effect For the Immolation power-up
-Improves online score-reliability in Case of server downtime/closure
-Improves menu-feedback on unvailable options
-Improves settings retention when quitting with ALT+F4 (Windows) Or Command+Q (Mac)
-Makes Chasers And Data Probes slightly faster
-Enumerates Display instead of using predefined resolutions
-Shows version And Current control setup in Help Screen
-Small tweaks To the on-screen instructions
-Adds speedhack detection

1.2.3
-Implement Threaded Score Submission
-Tweaks To the extra spawner
-Make the game start less dull
-Added customizable motion blur level
-Allow higher backbuffer quality settings
-Added New shot particle effects
-Made sound And music stop during pause mode
-Revised "NEAR MISS" system To be more sane
-Removed some exploitable debug routine
-Fixes bugs relating To resolution And display settings
-Added an all New enemy: the Data Probe
-Added one New background style
-Tweaked supershot Not To penetrate laser barriers & snake bodies
-Improved digipede AI behavior

1.2.2
-Improves background animation tweening For smoother animations
-Fixes changing To desktop resolution in full-screen mode Not being possible
-Fixes small graphical glitch in the help screen
-Fixes mouse getting lost during resolution switches
-Fixes aspect ratio changes Not immediately taking effect
-Fixed a bug where the spawns would be greatly reduced after reaching 3,3 million points
-Tweaked shot behavior To be more balanced
-Slightly increased enemy cap during endgame

1.2.1 (Silent)
-Fixed excessive screen re-inits on lost focus

1.2.1
-Fixed 'deep blacks' settings not being retained
-Fixed graphical garbage on task-switching in OS X Snow Leopard 10.6.8 And Lion
-Added notification For unsupported in-game fullscreen resolutions

1.2.0 (Maintenance)
-Widescreen Support
-Planned (Fix those two bugs)
-Sound Garbled Past 60 Million (Hottometsu)
-When launching bomb at the same time as picking up Tripleshot = Lots of Bombs

1.1.0
-Resoloved bug where the motion-blur would Not match the shot-color after changing seeds (For real this time)
-Added custom Graphics For "DUAL SHOT" power-up
-Further tweaks To the powerup spawner

1.0.9.1
-Hotfix For core seed Not showing up properly in the Main menu

1.0.9
-Adds End-game "DUAL SHOT" extra, which combines "BOUNCY SHOT" And "SUPER SHOT" extras
-Fixed a memory leak when changing the core seed repeatedly
-Resoloved bug where the motion-blur would Not match the shot-color after changing seeds
-Reduced likeliness of shield-extra early in game in favor of offensive extras
-Corrected some minor spelling errors
-Breaks compatibilitiy To 1.0.8 hiscore files
-Small CPU performance enhancements

1.0.8
-Fixed a bug, where the game would Not save the 'UP' key for the dual-analog input
-Fixed accidentally firing a bomb upon starting a game with a joystick connected
-Resolved a graphical glitch where 'Boids' and 'Data Fragements' would flash when hitting a 'MineLayer'
-Revised internal timing logic To be more efficient
-Re-Added 'Relative Mouse' control scheme, which controls similar to 'Asteroids'
-Added more End-game behaviours For the 'Thief' enemy type

1.0.5
-Fixed online hiscore table Not always displaying the correct rank
-Fixed several graphical bugs in the online hiscore table
-Fixed Not being able To set seeds above the divider line
-Fixed bottom-most online-scores Not displaying correctly in ranking


1.0.4.1 (Silent)
-Added timeout For difficulty stop when overwhelmed with enemies
-Timeout is always timed out after 3.3M points

1.0.4
-Difficulty increase is much more linear
-Multiplier trigger-values streamlined
-Seeds vary 10% more in their difficulty
-Triple cannon now guaranteed before 620.000 points
-Difficulty after 900.000 points reduced
-Moved game-speed increase from 1.100.000 To 1.900.000 points
-Buffed 'Thrust Boost' once more
-Small visual fix To the online hi-score list For very Long names
-Improved shot vs data fragment colision-code
-Fixed problem where few enemies would spawn, when starting a game
-Countless other small tweaks

1.0.3
-Made the action ramp up a bit quicker, shortening the initial lull
-Fixed the monthly HI-Score count Not displaying properly
-Better wording For the control setup screen (MOVE UP/DOWN instead of ACCELERATE/BRAKE)

ToDo:
-Implement Avatars (Probably delayed To post v1.0, If ever)
-Implement Data-Node Gameplay (Post 1.0)

Added:
-Better visual representation of invaders being infected
-The game can now ramp up the difficulty further For very late games (2million+ scores)
-Picking up 'Time Stretch' during frenzy extends Frenzy
-Small visual enhancements To "Framebuffer Effects OFF" mode
-Smarter auto-ordering OpenGL-Calls - slightly better performance
-Joystick 2 Axis Support?


-Smart Shuffle Function For the music player (Done)
-Create New Game-Icon! (Done)
-Create New Game Logo! (Done)
-Add New Music (Waiting For Carlo (11Tracks & Counting)
-Spruce up Gameplay, Tweak the Mechanics (35%)
-Balancing! (65%)
-Better Joystick Controls (75%)
-Implement Self-Scores Seed Management (55%)
-Final Bomb HUD Graphic (Completed)
-Time Display For Local Hi-Scores (Completed)
-Sparkling Glow (Completed)
-Screen Shake	(Completed)
-Implement Corruption (Completed)
-Seed Management (Completed)
-Keyboard/Joystick Menu (Completed)
-Sharing Seeds through the Highscore Table (Completed)
-Frenzy Bar & Frenzy Mode (Completed)
-New Control Scheme (Completed)
-HUD Fades whenever it gets in the way (Completed)
-Scores now wobble on generation (Completed)
-Colorful And Black & White Explosions Whee (Completed)
-Joystick Input (Completed)
-Score 1000's dotting (Tested, not good - Reverted)
-Score Obfuscation (Completed)
-Final Powerup Graphics (OK)
-Sound Loop Class (Completed)
-Added Preliminary Sounds by John Nesky (Final Sounds Added)
-Connected minelayer with coool effects And what Not! YAY!
-Stackable bombs And shields
-Scanline Effect For Data Nodes 50%
-Data Nodes
-New Powerups
-Thief, a vicious And interesting enemy
-Several Fixes To Minelayers & Powerups
-Toggleable V-Sync
-Implement Online Scoring (98%)
-Help Screen (50%)
-About/Info Screen (35%)

Bugs:
-There seems To be some bug with the frenzy mode (One time the bar never filled)

Fixed:
-Sometimes invaders would be removed While getting infected, without the infected replacement spawning
-In Rare circumstances the slow motion graphical effect would have slight glitches
-Made sure Timestretch always gets awarded properly
-Fixed lag when disconnecting joystick with joystick buttons configured (revert To Default kbd/mouse Input)
-Revised Icon To be more Crisp

-Wouldn't write ini settings upon forcing resolution change
-Would listen For key reconfiguration in the option screen even though the user clicked no particluar Input/action

-OnlineScore Always Returns Connection Failure when Submitting Score
-OnlineScore assumes connection failure when amount of online scores = 0
-Score retention bug between Online And Monthly Scores
-Runaway generation of "Starfield" And "GridHit" backgrounds when resetting the seed multiple times
-Bounce Flash playing even after bounce had ended
-P key being Not responsive when entering a name
-Mouse Lost Bug after losing windows focus
-Major rewrite To the Highscore Handling. Much, much more reliable And less To crash!
-Precache everything properly, getting rid of some lag For some people
-Improved Score Highlighting Visibility
-Made Menu more consistent, all toggle-able items are now Right-clickable
-Sanitized Powerup Pickup For Cannons
-Sanitized generate Notes Function To no longer use negative Arrays (Eugh!)
-Display warning message again when you can't connect - Whoops
-Score would highlight different players with same score
-UniqueID generation less crazy now, shouldn't code when tired
-Idiotic bug in positional audio that would speed up the sound in slowmo
-All sounds are now played over my positional audio Module
-Enemycount variable being off
-Memory leak caused by ParticleManager & Player respawn
End Rem
'-----------------------------------------------------------------------------
'Strict Code for better understandability
'-----------------------------------------------------------------------------
Strict
'-----------------------------------------------------------------------------
'Initialize FrameWork
'-----------------------------------------------------------------------------
'Below not needed for windows
?Win32
Framework BRL.GLMax2D
Import BRL.D3D7max2d
Import ODD.Aspect
?
?MacOs
Framework BRL.GLMax2D
'Framework ODD.GLOdd2D
?
'Import BRL.System
'Import pub.glew
Import BRL.PNGLoader
'Import BRL.Random
'Import BRL.Freetypefont
Import PUB.FreeJoy
Import BRL.Eventqueue
Import BRL.Wavloader
Import BAH.Random
'Online HighScore Module (Disabled Manuel Panasonic)
Import MAKEGAME.Highscore
Import koriolis.zipstream
?MacOs
Import BRL.FreeAudioAudio
Import BAH.Volumes
?
'Only for Windows (Compressed Datafile Support)
?Win32
Import BRL.DirectSoundAudio
?
'Load Module tracker Audio
Import MaxMod2.RtAudio
Import MaxMod2.OGG
'Import MaxMod2.DUMB
'Import MaxMod2.ModPlayer
Import BRL.Threads
?Win32
Import "game_icon.o"		'Load the application icon
?
'Global startupTime=MilliSecs()
'Global Versionstring:String =""

SetAudioStreamDriver("MaxMod RtAudio")
'-----------------------------------------------------------------------------
'Set Application Title
'-----------------------------------------------------------------------------
AppTitle="Invaders Corruption"'+VersionString
'-----------------------------------------------------------------------------
'Includes - stuff that I don't want in the main code because it looks messy
'-----------------------------------------------------------------------------
Include "includes\fixedratelogic.bmx"				'Includes Fixed rate logic for really smooth movement
Include "includes\centrewindow.bmx"					'Allows to center the window
Include "includes\loadassets.bmx"					'Improved loadimage and runtime error code
Include "includes\objecttypes.bmx"					'Gameplay-Relevant Types for the Player's ship etc.
Include "includes\menutypesbundle.bmx"				'Functions for Logos and Main Menus
Include "includes\fontlibrary.bmx"					'Sprite based font library to speed up font drawing
Include "includes\gaussianblur.bmx"					'Gaussian blur routines used for the bloom effect
Include "includes\rendertotexture.bmx"				'GL and DX render to texture algorithm for onscreen blur
Include "includes\mazegenerator.bmx"					'Generates Mazes using the "PRIM" algorithm, used for textures
Include "includes\globalfunctions.bmx"				'Various Global Functions, used throughout the game
Include "includes\keydefinitions.bmx"				'Contains the DefData for the various keyboard key names (Control setup)
'-----------------------------------------------------------------------------
'File self check
'-----------------------------------------------------------------------------
Rem
?MacOS
If CRC(AppFile,$90000)<>1342207877 Notify CRC(AppFile,$90000)
?
?Win32
If CRC(AppFile,$90000)<>-1840640802 Notify CRC(AppFile,$90000)
?
End Rem
'-----------------------------------------------------------------------------
'Game Speed
'-----------------------------------------------------------------------------
Const SLOW_FPS=30
Const FAST_FPS=200
'-----------------------------------------------------------------------------
'Threading and mutexes 
'-----------------------------------------------------------------------------
Global ThreadMutex:TMutex = Brl.Threads.CreateMutex ()
Global ScoreMutex:TMutex = Brl.Threads.CreateMutex ()
Global Thread:TThread
'Score Submission Temps
Global TempName:String
Global TempScore:String
Global TempSeed:String
Global TempPlayTime:String
Global TempTrack:String
'Exit code for Thread
Global AbortThread:Byte
Global ReturnFromThread:Byte
'-----------------------------------------------------------------------------
'Detect Screen Aspect and set up Game Accordingly
'-----------------------------------------------------------------------------
Global ReInitGraphics:Byte=False
Global ForceGraphics:Byte=False
'Widescreen Byte
Global WideScreen:Byte
'Widescreen Graphics Mode Arrays
Global WidescreenWidth:Int[20]
Global WidescreenHeight:Int[20]
'Tallscreen Graphics Mode Arrays
Global TallscreenWidth:Int[20]
Global TallscreenHeight:Int[20]
'Desktop Width and Height
Global DWidth:Int=DesktopWidth()
Global DHeight:Int=DesktopHeight()
'RecommendedResolutions
Global RecommendedWideHeight:Int
Global RecommendedWideWidth:Int
Global RecommendedTallHeight:Int
Global RecommendedTallWidth:Int

If Float(DWidth)/Float(DHeight)=>1.38
	WideScreen=True
Else
	WideScreen=False
End If

'Get Graphics Modes
EnumerateGraphics()

Global ScreenWidth:Int 
Global ScreenHeight:Int
'Virtual Resolution - This is the res the Math runs at.
If WideScreen=True
	ScreenWidth = 1280					
	ScreenHeight = 768
Else
	ScreenWidth = 1024
	ScreenHeight = 768
End If

'-----------------------------------------------------------------------------
'Constants
'-----------------------------------------------------------------------------
'Const EncKey:String = "#RenderWindow=True;" 				'HighScore Transmission encryption key
Global EncKey:String = SeedJumble(")Xktjkx]otju}CZx{kA",False)
'Const LocalKey:String= "renjiasanoDP:YaY!"
Global LocalKey:String = SeedJumble(".=.{kA;x.tpo+gygtuJV@_g_'@!",False)
'Const LocalKey$ = "renjio23h51241::sad" 			'HighScore Local encryption key
Global multiplieramount:Int[] = [35,75,145,275,465,720,945,1260,1585,2120,2860,3500,4360,5095,6105,7310,8820,11400,15250,23200]
'-----------------------------------------------------------------------------
'Windows datafile parser
'-----------------------------------------------------------------------------
'Only for Windows, keep all data in one large file for order
?Win32
SetZipStreamPasssword("data.big",SeedJumble(SeedJumble("Ygtozgx]Fyn7?77'",False),False))
If FileSize("data.big")<=10200000 Then RuntimeError "Main datafile has been deleted or damaged.~nPlease redownload the game."
?
?MacOS
SetZipStreamPasssword(GetbundleResource("data.big",True),SeedJumble(SeedJumble("Ygtozgx]Fyn7?77'",False),False))
If FileSize(GetbundleResource("data.big",True))<=10200000 Then RuntimeError "Main datafile has been deleted or damaged.~nPlease redownload the game."
?
'-----------------------------------------------------------------------------
'Universal Globals
'-----------------------------------------------------------------------------
'Duplicate Instance Handling
?Win32
Global DuplicateClose:Byte = False
?
'General Graphics and Windows Stuff
'Global FirstTime=True
Global GraphicsWindow:TGraphics					'The container for the gadget graphics
Global WindowMinimized:Int = False					'Is the window Minimized
Global RealWidth:Int = 1024
Global RealHeight:Int = 768
Global ClsColor:Int=$FF050505						'Screen clearing Color Default
Global KeyNames:String[300]						'Actual Key names for Keyboard setup
Global InputKey:Int[16]							'The Scancodes for the relevant keys
Global InputCache:Int[16,5]							'Cache the inputs for various methods
'important game timing stuff
Global ExitCode:Int = False						'Program ends when true
Global Delta:Double								'Frame Delta for smooth movement inbetween frames
Global Logic_LostFocus:Int = False 
Global PreviousFPS:Double						'Store the current framerate for Pause modes
Global RemainingSlowMo:Int						'Remaining Slowmotion time when Pause
'graphics settings
Global GraphicsDriver:Int = 2						'1 is directx 2 is opengl
Global GlLines=True								'If false lines are drawn with the slower internal BlitzMax commands
Global RefreshRate:Int = 60
Global BitDepth:Int = 32
Global FullScreen:Int = 0
Global VerticalSync:Int = -1
Global ParticleMultiplier:Float = 1				'Adjust the amount of particles displayed
Global ForceRes:Int=False
Global FullscreenGlow:Int=True
Global BackgroundStyle:Int=1						'The style for the game of life background
Global UseSeedStyle:Byte=0						'Always use seed backgrounds
Global SeedBackStore:Int						'Stores the seed background
Global GlowQuality:Int=256						'Glow Texture Size
Global MotionBlurEnable:Int=True					'Enable Motion Blur
Global BlurDivider:Float=2.4						'Blur Multiplier
Global ScreenShakeEnable:Int=True
'Global CorruptionEffectEnable=True
Global ChangedSeedRecently:Byte=False
Global EasterEgg:Byte=False
Global NoExplode:Byte=False
Global DoEasterEggOnce:Byte
Global Keen4E:Byte=False
Global WipeOutOnce:Int=0						'Fire the WIPE OUT bonus only once with a 12.5s timer
Global WipeOutOncePause:Int=0					'Retain Wipeout time during pause
Global HasSuperShotPause:Int=0
Global HasBouncyShotPause:Int=0
Global HasFrenzyPause:Int=0
Global GunPickupPause:Int=0
Global PureBlacks:Int=False						'Lightens the Black level a bit so bloom stands out more
Global CrossHairType:Int=1						'Image used for the mouse cursor
Global ToolTip:String=""						'Tooltips displayed next to the cursor
Global HudVisibility:Float=0					'Fades the HUD in or out when the player is underneath it
Global HudBombVisibility:Float=0
Global HudFrenzyVisibility:Float=0
Global GUIFadein:Float=0
Global LogoFlickerOffset:Float[55]
Global LastDifficultyDowngrade:Int
Global SpawnQueueFull:Int
Global FirstMassSpawn:Int
'Help Screen Variables for displaying the ever changing invaders
Global nextinvader:Int=1
Global LastSwitch:Int=MilliSecs()
'Graphics Handler for rotation Matrix
Global GraphicInfo:TMax2dGraphics = TMax2dGraphics.Current()
'Default Sound Settings
Global SoundVolInt:Int=85
Global MusicVolInt:Int=45
Global SoundVol:Float=0.85
Global MusicVol:Float=0.45
Global SoundMode:Byte=1
Global SoundMute:Byte=False
Global PreviousSoundMute:Byte=False
Global Note:Float[36]
Global LoopChannel:TChannel	'Looping channel specifically for looping sounds (Laser Barrier)
LoopChannel = AllocChannel()
'Color Cycling Variables for the Cursor
Global RCol:Float=250
Global GCol:Float=20
Global BCol:Float=20
Global RColDelta:Float=-3
Global GColDelta:Float=5
Global BColDelta:Float=7
'Name and location of the Highscores file
Global HelpToggle:Byte=False
'Mac OSX
?MacOs
Global HighScoreFile:String = GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/hiscores.dat"
?
'Windows
?Win32
Global HighScoreFile:String = "hiscores.dat" 
?
'Screenshot counter
Global ScreenshotNumber:Int
'Intro Fade Timers
Global FadeTimer:Float
Global IntroStep:Int=1								'Position of the intro "Playlist"
Global ScanlineFader:Float
'Mouse Coordinates
Global XMouse:Float=ScreenWidth/2,YMouse:Float=ScreenHeight/2
Global prevMouseX:Int, prevMouseY:Int
Global FilterMouseXSpeed:Int,FilterMouseYSpeed:Int
Global MouseSensivity:Int=10
Const SAFEZONE=165									'Safe zone for the actual mouse to move in
Global CenterMouseX:Int,CenterMouseY:Int
'Color Conversion Globals
Global GlobalSaturation:Float=-1
Global GlobalBrightness:Float=-1
Global Result_R:Float, Result_G:Float, Result_B:Float
Global Result_L:Float, Result_H:Float, Result_S:Float
'-----------------------------------------------------------------------------
'AI Director Globals
'-----------------------------------------------------------------------------
Global CloseEncounters:Float						'A generic counter for how well the player is doing
Global SpawnInterval:Int							'Spawninterval can be regulated up or down
Global SpawnPause:Int								'Timer during which spawns are disallowed in Milliseconds
Global ComfortZone:Int=91							'Zone in which enemy movement will be registered
Global ExtraLikeliness:Int							'Additional Likeli or unlikeliness that Extras Spawn
Global ForceExtra:Int
Global BreakTime:Int
Global DifficultyUpgradePause:Int
Global SeedDifficultyChange:Float
Global SeedDifficultyJudge:Float
Global ScoreMultiplier:Float = 1.0					'Score Multiplier - Changes according to difficulty bracket
'-----------------------------------------------------------------------------
'Spawn location Constants
'-----------------------------------------------------------------------------
Const CORNER=0
Const RNDCORNER=1
Const BORDER=2
Const RNDBORDER=3
Const SCATTER=4
Const CLUSTER=5
Const SURROUND=6
Const POINT=7
Const SPECIAL=8
'-----------------------------------------------------------------------------
'Enemy type Constants
'-----------------------------------------------------------------------------
Const BOUNCER=0
Const ERRATIC=1
Const FOLLOWER=2
Const AASTEROID=3
Const EVADER=4
Const THIEFBOT=5
Const PANICER=6
Const MMINELAYER=7
Const DATPROBE=8
Const PAUSE1=9
Const WEAVER=10
Const SSNAKE=11
Const CORRUPTNODE=12
Const PAUSE2=13
Const SMARTIE=14
Const CONNECTEDMINELAYER=15
Const FLOCK=16
Const FEARLESSTHIEF=17
Const MOTHERSHIP=18
Const BOSS=19
Const SPAWNER=20
Const MEGA=21
Rem
Const BOUNCER=0
Const ERRATIC=1
Const FOLLOWER=2
Const EVADER=3
Const THIEFBOT=4
Const PANICER=5
Const AASTEROID=6
Const WEAVER=7
Const MMINELAYER=8
Const SSNAKE=9
Const SMARTIE=10
Const CONNECTEDMINELAYER=11
Const FLOCK=12
Const CORRUPTNODE=13
Const CORRUPTEDONE=14
Const MOTHERSHIP=15
Const BOSS=16
Const SPAWNER=17
Const MEGA=18
End Rem
'-----------------------------------------------------------------------------
'Helper Globals
'-----------------------------------------------------------------------------
'General Input Processing
Global CursorInterval:Int=MilliSecs()			'Useful Interval timer for ALL cursors in the game
Global InputMethod = True					'Enable or disable InputMethod
Global AutoFire:Byte = False
'GAME STATE
Const WAITING = 0							'Waiting for player to play	
Const PLAYING = 1							'Is playing..
Const DEAD = 6								'Player lost his final life
Const MENU = 4								'Is in menu (May be in game)
Const PAUSE = 3							'Game Paused
Const HISCORE = 5							'Doing Highscores (Likely after death)
Const READY = 2							'GET READY screen, but not yet playing
Const FIRSTSTART=-1							'The Game was just launched
Const CREDITS=42							'Displaying Credits
Const VIEWHELP=666							'Getting the keyboard/mouse/joypad input for config
Global GameState=FIRSTSTART					'State of the game now
'GAME MODE
Const ARCADE=0								'Arcade Mode - The Standard Mode of Play
Const FREEPLAY=1							'Just play until your ship dies
Const DEFENDER=2							'Defend the base against the Invaders
Const VIEWSCORE=3							'Just viewing the Highscore Table
Const VIEWONLINE=4							'Viewing the online TOP20 Highscore Table
Const VIEWRANK=5							'Viewing the Ranking VS World
Const CLASSIC=6							'Playing Classic Space Invaders
Global GameMode=ARCADE						'What is being played - Freeplay? Arcade?
'PLAYER IS TYPING
Global TYPING:Byte=False							'Is the player currently typing? Important for input polling.
Global AUTOPAUSE:Byte=False						'Have we paused because of lost focus?
'Movement key constants
Const MOVE_UP=1
Const MOVE_DOWN=2
Const MOVE_LEFT=3
Const MOVE_RIGHT=4
Const FIRE_CANNON=5
Const FIRE_BOMB=6
'Dual Axis Control Constants
Const AIM_UP=7
Const AIM_DOWN=8
Const AIM_RIGHT=9
Const AIM_LEFT=10
'Joystick Deadzone for all axis
Global JoyDeadZone:Float[16]
Global JoyDeadZoneAdjust:Int=1
'-----------------------------------------------------------------------------
'Player Tracking
'-----------------------------------------------------------------------------
Global Trk_Inv:Int
Global Trk_Toggle:Int
Global Trk_Bmb:Int
Global Trk_Bmb_Up:Int
Global Trk_Sht:Int
Global Trk_Frnz:Int
Global Trk_FrnzGn:Int
Global Trk_Sht_Up:Int
Global Trk_Str:String
Global Trk_Diff:Int
Global Trk_Shd:Int
Global Trk_NDeath:Int
Global Trk_Sum:Int
Global Trk_Mul:String
Global Trk_Redflag:Byte
'-----------------------------------------------------------------------------
'Game Globals
'-----------------------------------------------------------------------------
'Stores the current avatar (CORE SEED) Sprite
'Global SeedAvatar:Int[32]
'The players UNIQUE ID
Global UniqueID:String
Global ConnectScoreServer:Byte=False
'Game Settings
Global FieldWidth:Int
Global FieldHeight:Int
'Change Playfield Sizes According to Widescreen Setting
If WideScreen=False
	FieldWidth = 1024					'Star or Playfield Size
	FieldHeight = 768
Else
	FieldWidth = 1280
	FieldHeight = 768
End If
'ViewPort Definition
'Global ViewPortX:Double = 0'FieldWidth/2		'The initial Location of the Camera
'Global ViewPortY:Double = 0'FieldHeight/2	
Global FPSTarget:Float = 200					'The Target Framerate
Global FPSCurrent:Float = 200					'The Current Framerate
'Game Timer Variables
Global PlaySecs:Float=0, DeathSecs:Float=0, CountSecs:Float=10
Global READYTimer:Int=0
Global PauseTime:Long
Global PauseSecs:Long						'Keep track of the Game-time during pause
Global GameTicks:Int
Global GameStartTime:Int
Global SpeedGain:Float
Global RandomGain:Float
'Tick Measurement
Global TickAverage:Int
Global BackgroundTick:Int 'Timer for background animations, ticks in millisecs
Global LifeTick:Int 'Timer for the game of life 
Global HUDTick:Int 'Timer for HUD Updates
Global GUITick:Int
'Player Globals
Global PlayerName:String = ""
Global DeathBy:String=""
Global Seed:String=""
Global WriteMask:Int=Rand(-4096,6500384)			'Score Obfuscation Variable
Global OpenGLHash:Int=Rand(-13024,4999999)			'Score Obfuscation Variable
Global Score:Int=WriteMask
Global BestScore:Int=0
Global LargestScore:Int=0
Global EnemiesKilled=0
Global NearMissCount=0						'Number of recent "NEAR MISS"es.
Global NearMissID:String=""
Global Difficulty:Int=1
Global LastDifficultyChange:Int=0
Global EnemyCount=0
Global Multiplier:Int=1
Global OldMultiplier:Int=1
Global Frenzy:Int=0
Global FrenzyGraph:Double=0
Global FrenzyMode:Int=0
Global PulseTime:Int=0 'Pulses the frenzy bar when not enough enemies are available to launc the frenzy
'Global FrenzyR:Int=256
Global FrenzyG:Int=255
Global FrenzyB:Int=255
'Flushed the keys on death once
Global FlushedOnce:Byte
'-----------------------------------------------------------------------------
'Type Lists
'-----------------------------------------------------------------------------

'Create a new fixed rate logic
Global FixedRateLogic: TFixedRateLogic = New TFixedRateLogic
FixedRateLogic.Create()

'Gameplay Relevant
Global Player:TPlayerShip = New TPlayerShip
Global Shot:TShot = New TShot
Global PlayerBomb:TPlayerBomb = New TPlayerBomb
'Global Rock:TRock = New TRock
Global Invader:TInvader = New TInvader
Global Spinner:TSpinner = New TSpinner
Global Snake:TSnake = New TSnake
Global Chaser:TChaser = New TChaser
Global Minelayer:TMinelayer = New TMinelayer
Global Mine:TMine = New TMine
Global Asteroid:TAsteroid = New TAsteroid
Global Boid:TBoid = New TBoid
Global Thief:TThief = New TThief
Global DataProbe:TDataProbe = New TDataProbe

'Corruption Related
Global Corruption:TCorruption = New TCorruption
Global CorruptionNode:TCorruptionNode = New TCorruptionNode
Global CorruptedInvader:TCorruptedInvader = New TCorruptedInvader

Global PowerUp:TPowerUP = New TPowerUp
'Score Tracking
Global HighScore:THighscore = New THighscore
Global ScoreRegister:TScoreRegister = New TScoreRegister
Global BombHUD:TBombHud = New TBombHud
'Visual Effects
Global Thrust:TThrust = New TThrust
Global ShotGhost:TShotGhost = New TShotGhost
Global Flash:TFlash = New TFlash
Global Explosion:TExplosion = New TExplosion
Global ShockWave:TShockWave = New TShockWave
Global Lightning:TLightning = New TLightning

Global Glow:TGlow = New TGlow

Global SpawnEffect:TSpawnEffect = New TSpawnEffect
Global SpawnQueue:TSpawnQueue = New TSpawnQueue
Global MotionBlur:TMotionBlur = New TMotionBlur
'Global CorruptionEffect:TCorruptionEffect = New TCorruptionEffect
'Global Reacher:TReacher = New TReacher
'Global DataNode:TDataNode = New TDataNode

Global Background:TBackground = New TBackground
Global BoxedIn:TBoxedin = New TBoxedIn
Global Squared:TSquared = New TSquared
Global UpRising:TUpRising = New TUpRising
Global GridHit:TGridHit = New TGridHit
Global Water:TWater = New TWater
'The Main Menu Type
Global MainMenu:TMainMenu=New TMainMenu
'The Online-HighScore Type
Global OnlineScore:TOnlineHighScore = New TOnlineHighScore.InitHighScore("127","www.manuelvandyck.com","/cor_scores/_hgh.php", 80)
Global ScoreServer:TScoreServer = New TScoreServer

Global GameOfLife:TGameOfLife = New TGameOfLife

'Time keeping Daemon
Global SpeedCheck:TSpeedCheck = New TSpeedCheck

'-----------------------------------------------------------------------------
'Load ini File And set Screen Parameters
'-----------------------------------------------------------------------------
LoadIniFile()		'Load settings from settings.ini
InitGraphics(False,True)		'Check the graphics card and prepare for drawing the game
'HideMouse()

'-----------------------------------------------------------------------------
'Do Win32 Stuff
'-----------------------------------------------------------------------------
'Only in D3D graphicsmode add a minimize button as it tends to crash the gl draw cycle
?Win32
InitW32()
Local Extension:String=Right(AppFile,4)
SetIcon((StripAll(AppFile)+Extension), GetActiveWindow())
'SetIcon(AppFile, GetActiveWindow())
FindDuplicateInstances()
?
'-----------------------------------------------------------------------------
'Load Deferred Assets (Graphics, Sounds, Data)
'-----------------------------------------------------------------------------
Global BoldFont:TBitMapFont = TBitMapFont.Create(GetBundleResource("fonts/visitor"))
'Global BoldFont:TBitMapFont = TBitMapFont.Create("fonts/metroid")


'Disable automatic garbage collection
GCSetMode(1)

'----------------------------------------------------------
' THESE SOUNDS ARE USED IN THE SEED GETTING, LOAD EM
'----------------------------------------------------------

Global Sound_Ultra:TSound = LoadSound(GetBundleResource("sounds/ee_shotty.wav"))
Global Sound_Keen:TSound = LoadSound(GetBundleResource("sounds/ee_keen.wav"))

'----------------------------------------------------------
' GET THE RANDOM SEED IF WE HAVENT YET
'----------------------------------------------------------

GetRandSeed(True)

Cls
SetColor 255,255,255
'Show what we are doing - loading...
Invader.Preview ScreenWidth/2-77,ScreenHeight/2,1
BoldFont.Draw "Loading...",ScreenWidth/2+24,ScreenHeight/2-15,True
Flip
Delay (1)

'Count the number of screenshots in the screenshot folder
GetScreenShotNumber()

SeedRnd MilliSecs()+MouseX()+MouseY()/2
TreeLogo.Render(False)

Local SeedVal:Int
For Local i=1 To Len(Seed)
	SeedVal:+Asc(Mid$(Seed,i,1))*(i/2)
Next
	
SeedRnd (SeedVal)
RandomGain=Rnd(-.08,0.115)
SeedDifficultyChange=Rnd(0.82,1.15)
SeedRnd (SeedVal)
	
Invader.Generate(1)

'Initialize Render2Texture
Global BloomFilter:TImage = tRender.Create(GlowQuality,GlowQuality) 
tRender.Cls

'Calculate Octaves for Sound Shift
GenerateNotes()
'WaitKey()
'Perform some CRC checks on the Savefile to see if someone tampered with it

Global DoubleBoldFont:TBitMapFont = TBitMapFont.Create(GetBundleResource("fonts/fruittwo"),MASKEDIMAGE)

Global IngameFont:TBitMapFont = TBitMapFont.Create(GetBundleResource("fonts/visitor"))

Global ScoreFont:TBitMapFont = TBitMapFont.Create(GetBundleResource("fonts/score"))

BoldFont.PreCache()
IngameFont.PreCache()
ScoreFont.PreCache()
DoubleBoldFont.PreCache()

'Global MouseCursor:TImage = LoadImage(GetBundleResource("graphics/cursor.png"),MASKEDIMAGE)
Global MouseCursor:TImage = LoadAnimImage(GetBundleResource("graphics/cursor.png"),32,32,0,6,MASKEDIMAGE)
MidHandleImage MouseCursor
PrepareFrame(MouseCursor)

Global PresentStatic:TImage = LoadAnimImage(GetBundleResource("Graphics/presentstatic.png"),460,46,0,3,MASKEDIMAGE)
MidHandleImage PresentStatic

'Image Logos
Global GameLogo:TImage = LoadImage(GetBundleResource("graphics/gamelogo.png"),MASKEDIMAGE)
Global GameBuzz:TImage = LoadImage(GetBundleResource("graphics/gamebuzz.png"),MASKEDIMAGE)
'Global GameLogo:TImage = LoadImage(GetBundleResource("graphics/gamelogo.png"),MASKEDIMAGE)
MidHandleImage GameLogo
MidHandleImage GameBuzz
'ccCreateFrames(ImageCredits)

Global FrenzyBar:TImage = LoadImage(GetBundleResource("graphics/frenzybar.png"),MASKEDIMAGE)
Global FrenzyMeter:TImage = LoadImage(GetBundleResource("graphics/frenzymeter.png"),MASKEDIMAGE)
'Global BombIcon:TImage = LoadImage(GetBundleResource("graphics/bombicon.png"),MASKEDIMAGE)
PrepareFrame(FrenzyBar)
'PrepareFrame(BombIcon)
PrepareFrame(FrenzyMeter)

'Render our generative Logo and store it in the Backbuffer for further use
TreeLogo.Render(True)

'Set up Faders
Global IntroFade:TFade=TFade.CreateColorFade()
Global PresentsFade:TFade=TFade.CreateColorFade()
Global MenuFade:TFade=TFade.CreateColorFade()
Global FinalFade:TFade=TFade.CreateColorFade()

'General Menu Sounds
Global Sound_Menu_Hover:TSound 				= LoadSound(GetBundleResource("sounds/menu_hover.wav"))
Global Sound_Menu_Click:TSound 				= LoadSound(GetBundleResource("sounds/menu_click.wav"))
Global Sound_Menu_No:TSound 				= LoadSound(GetBundleResource("sounds/menu_no.wav"))

'Game State Sounds
Global Sound_Game_Start:TSound 				= LoadSound(GetBundleResource("sounds/game_start.wav"))
'Global Sound_Game_Over:TSound 				= LoadSound(GetBundleResource("sounds/game_over.wav")
'Global Sound_Game_Dead:TSound 				= LoadSound(GetBundleResource("sounds/game_dead_loop.wav")
'Global Sound_Game_Tension:TSound 			= LoadSound(GetBundleResource("sounds/game_tension.wav")
'Global Sound_Game_Multiplier:TSound 			= LoadSound(GetBundleResource("sounds/game_multiplier.wav")
Global Sound_Game_Frenzy:TSound				= LoadSound(GetBundleResource("sounds/game_frenzy.wav"))
Global Sound_Game_Multiplier:TSound			= LoadSound(GetBundleResource("sounds/game_multiplier.wav"))
Global Sound_Game_Presents:TSound			= LoadSound(GetBundleResource("sounds/game_presents.wav"))
Global Sound_Game_Logo:TSound				= LoadSound(GetBundleResource("sounds/game_logosizzle.wav"))

'Player Sounds
Global Sound_Player_Shot:TSound 			= LoadSound(GetBundleResource("sounds/player_shot.wav"))
Global Sound_Player_Super_Shot:TSound 		= LoadSound(GetBundleResource("sounds/player_shot_super.wav"))
Global Sound_Player_ShotFizzle:TSound 		= LoadSound(GetBundleResource("sounds/player_shot_fizzle.wav"))
Global Sound_Player_ShotHit:TSound			= LoadSound(GetBundleResource("sounds/player_shot_hit.wav"))
Global Sound_Player_Pickup:TSound 			= LoadSound(GetBundleResource("sounds/player_pickup.wav"))
Global Sound_Player_Maxed:TSound 			= LoadSound(GetBundleResource("sounds/player_pickup_maxedout.wav"))
Global Sound_Player_Shield_Die:TSound 		= LoadSound(GetBundleResource("sounds/player_shield_die.wav"))
Global Sound_Player_Rebound:TSound 			= LoadSound(GetBundleResource("sounds/player_rebound.wav"))
Global Sound_Player_Bomb:TSound 			= LoadSound(GetBundleResource("sounds/player_bomb.wav"))

'Enemy Sounds
Global Sound_Snake_Born:TSound				= LoadSound(GetBundleResource("sounds/enm_snake_born.wav"))
Global Sound_Spinner_Born:TSound			= LoadSound(GetBundleResource("sounds/enm_spinner_born.wav"))
Global Sound_ErraticSpinner_Born:TSound		= LoadSound(GetBundleResource("sounds/enm_spinner_erratic_born.wav"))
Global Sound_Invader_Born:TSound			= LoadSound(GetBundleResource("sounds/enm_invader_born.wav"))
Global Sound_ScaredInvader_Born:TSound		= LoadSound(GetBundleResource("sounds/enm_invader_cautious_born.wav"))
Global Sound_WeaverInvader_Born:TSound		= LoadSound(GetBundleResource("sounds/enm_invader_wasp_born.wav"))
Global Sound_DataFragment_Born:TSound		= LoadSound(GetBundleResource("sounds/enm_datafragment_born.wav"))
Global Sound_Chaser_Born:TSound				= LoadSound(GetBundleResource("sounds/enm_chaser_born.wav"))
Global Sound_Chaser_Surprised:TSound			= LoadSound(GetBundleResource("sounds/enm_chaser_surprised.wav"))
Global Sound_Minelayer_Born:TSound			= LoadSound(GetBundleResource("sounds/enm_minelayer_born.wav"))
Global Sound_Boid_Born:TSound				= LoadSound(GetBundleResource("sounds/enm_boid_born.wav"))
Global Sound_Corruption_Born:TSound			= LoadSound(GetBundleResource("sounds/enm_corruption_born.wav"))
Global Sound_Corruption_Infect:TSound		= LoadSound(GetBundleResource("sounds/enm_corruption_infect.wav"))
Global Sound_Thief_Born:TSound				= LoadSound(GetBundleResource("sounds/enm_thief_born.wav"))
Global Sound_Thief_Steal:TSound				= LoadSound(GetBundleResource("sounds/enm_thief_steal.wav"))
Global Sound_Mine_Born:TSound				= LoadSound(GetBundleResource("sounds/enm_mine_born.wav"))
'Data Probe sounds here
Global Sound_DataProbe_Born:TSound				= LoadSound(GetBundleResource("sounds/enm_probe_born.wav"))
Global Sound_DataProbe_Boost:TSound				= LoadSound(GetBundleResource("sounds/enm_probe_boost.wav"))

'Neutral Sounds
Global Sound_Powerup_Born:TSound			= LoadSound(GetBundleResource("sounds/nt_powerup_born.wav"))
Global Sound_Powerup_Time:TSound			= LoadSound(GetBundleResource("sounds/nt_powerup_timeout.wav"))
Global Sound_Shatter:TSound					= LoadSound(GetBundleResource("sounds/nt_shatter.wav"))
Global Sound_Explosion:TSound				= LoadSound(GetBundleResource("sounds/nt_explosion.wav"))
Global Sound_Explosion_Big:TSound			= LoadSound(GetBundleResource("sounds/nt_explosion_big.wav"))
Global Sound_Explosion_Huge:TSound			= LoadSound(GetBundleResource("sounds/nt_explosion_huge.wav"))
Global Sound_Laser_Barrier:TSound			= LoadSound(GetBundleResource("sounds/nt_laser_barrier.wav"))
Global Sound_Time_Slow:TSound				= LoadSound(GetBundleResource("sounds/nt_time_slow.wav"))
Global Sound_Time_Fast:TSound				= LoadSound(GetBundleResource("sounds/nt_time_fast.wav"))

'Load Easter Egg Sounds
Global Sound_Keen_Pogo:TSound = LoadSound(GetBundleResource("sounds/ee_pogo.wav"))
'-----------------------------------------------------------------------------
'Music Preload
'-----------------------------------------------------------------------------
Global GameOverSong:TBank = LoadBank(GetBundleResource("music/gameover.ogg"))
Global Song1:TBank = LoadBank(GetBundleResource("music/song1.ogg"))
Global Song2:TBank = LoadBank(GetBundleResource("music/song2.ogg"))
Global Song3:TBank = LoadBank(GetBundleResource("music/song3.ogg"))
Global Song4:TBank = LoadBank(GetBundleResource("music/song4.ogg"))
Global Song5:TBank = LoadBank(GetBundleResource("music/song5.ogg"))
Global Space_Invaders:TBank = LoadBank(GetBundleResource("music/spaceinv.ogg"))

Global MusicChannel_One:TChannel=AllocChannel()
Global MusicChannel_Two:TChannel=AllocChannel()
'Global SoundLoop:TSoundLoop = New TSoundLoop
Global MusicPlayer:TMusicPlayer = New TMusicPlayer

MusicPlayer.Init()

SetChannelVolume MusicChannel_One, MusicVol/1.35

SetBlend ALPHABLEND
GCSuspend()

'SetImageFont ImageFont
'Initialize Objects and load the remaining Linked-Assets
Local Trash:Byte

Background.Generate(ScreenWidth,ScreenHeight)
Squared.Generate(ScreenWidth,ScreenHeight)
Invader.Generate(150)
Spinner.Generate(150)
Snake.Generate(65)
Chaser.Generate(55)
Minelayer.Generate(30)
Mine.Generate(30)
Asteroid.Generate(45)
Boid.Generate(40)
Player.Generate()
'DataNode.Generate(15)
Thief.Generate(55)
Shot.Generate()

GameOfLife.Init()
TStarfield.Init(256)
GridHit.Generate(ScreenWidth,ScreenHeight)
Corruption.Generate(ScreenWidth,ScreenHeight,35)
CorruptionNode.Generate(23)
CorruptedInvader.Generate(55)
'RandomGain=Rnd(-.08,0.115)
Trash=Rnd(-.08,0.115)
SetupKeyTable()

MainMenu.Init()
Lightning.Init()
BombHUD.Init()
ParticleManager.Init()
Glow.Init()
'MotionBlur.Init()
ShotGhost.Init()
MotionBlur.Init()
Thrust.Init()
DataProbe.Generate(55)
BoxedIn.Init()
GridHit.Init()
UpRising.Init()
If Rand(0,100)>70 Then
	Player.TwinEngine=True
Else
	Player.TwinEngine=False
End If'Shot.Generate()
'SeedDifficultyChange=Rnd(0.82,1.15)
Trash=Rnd(0.82,1.15)
Water.Init()
'If this is the very first time starting we'll select a background based on the core seed
If BackgroundStyle=-1 Or UseSeedStyle
	BackgroundStyle=Rand(1,15)
	SeedBackStore=BackgroundStyle
Else
	SeedBackStore=Rand(1,15)
End If
If UniqueID="" UniqueID=GenerateUniqueID(Seed)
'Get seed Difficulty levels
SeedDifficultyJudge=Abs(100-((SeedDifficultyChange-.82)/.43)*100)
SeedDifficultyJudge:+(((RandomGain+.08)/.195)*100)*2 'Enemy speed is weighted x2
SeedDifficultyJudge:/3
'Print FloatRound(SeedDifficultyJudge,2)
If SeedDifficultyJudge<=20
	ScoreMultiplier=.125
Else If SeedDifficultyJudge<=30
	ScoreMultiplier=.25
Else If SeedDifficultyJudge<=45
	ScoreMultiplier=.5
Else If SeedDifficultyJudge<=55
	ScoreMultiplier=.75
Else If SeedDifficultyJudge<=65
	ScoreMultiplier=1.0
Else If SeedDifficultyJudge<=85
	ScoreMultiplier=1.25
Else If SeedDifficultyJudge<=95
	ScoreMultiplier=1.5
Else
	ScoreMultiplier=1.75
End If

Trk_Mul = SeedJumble(String(ScoreMultiplier),False,False)

'Do Easter Egg Stuff
Local SeedTest:String=SeedJumble(Seed)
If SeedTest="@LJJ>KABOHBBK" Or SeedTest="HBBK1B"
	'If SoundPlay PlaySoundBetter Sound_Keen,ScreenWidth/2,ScreenHeight/2,False,False
	Keen4E=True
End If

If SeedTest="RIQO>SFLIBK@B"
	RandomGain=.42
	'If SoundPlay PlaySoundBetter Sound_Ultra,ScreenWidth/2,ScreenHeight/2,False,False
	SeedDifficultyJudge=666.00
End If
	
If SeedTest="EROQJBMIBKQV"
	RandomGain=.34
	'If SoundPlay PlaySoundBetter Sound_Ultra,ScreenWidth/2,ScreenHeight/2,False,False
	SeedDifficultyJudge=101.00
End If

If SeedTest="@>Q@E//"
	PlayerName="YOSSARIAN LIVES"
End If

If SeedTest="P>IFKDBO"
	PlayerName="HOLDEN CAULFIELD"
End If

If SeedTest="QEBA>OHQLTBO"
	PlayerName="ROLAND"
End If

If SeedTest=">MMIBFF" Or SeedTest="@LJJLALOBPRMBOMBQ" Or SeedTest=">MMIBFFB" Or SeedTest="@LJJLALOBMBQ" Or SeedTest="EB>QEHFQE56" Or SeedTest="PFOFRP." Or SeedTest="SF@QLO6---"
	EasterEgg=True
	BackgroundStyle=3
	GlowQuality=256
	'InitGraphics()
ElseIf SeedTest.Contains("?I>@H") And SeedTest.Contains("TEFQB")
	EasterEgg=2
ElseIf SeedTest.Contains("PEFOL") And SeedTest.Contains("HROL")
	EasterEgg=2
ElseIf SeedTest.Contains("KLFO") And SeedTest.Contains("?I>K@")
	EasterEgg=2
ElseIf SeedTest = "LIAP@ELLI"
	BackgroundStyle=6
	Player.TwinEngine=False
	EasterEgg=0
Else
	EasterEgg=False
End If

'Prepare Startup
GameInit(False)
UpRising.WarmUp()
GCResume()
GCCollect()
MainMenu.UpdateOptionStates()
'Wait another 75MS to settle down, just to be sure
Delay(75)
'Print MilliSecs()-StartupTime
'-----------------------------------------------------------------------------
'Debug Various & Lost and Found
'-----------------------------------------------------------------------------
'Debug Option for Player Invincibility for easier problem checking...
'If GameMode=Twitter Then
'Player.Invincible=True
'End If
'FPS Counting Variables for Debug
'Global tim:Int = MilliSecs() 
'Global counter:Int
'Global FPS:Int
'Global Debug=False
'Global CPUTime:Int
'Global GFXTime:Int
'Global AiTime:Int
'Global InputTime:Int
'Global GameTime:Int
'Global SpawnBlock:Int=False

'Global SoundPitching:Int=True
'Global ShootingSounds:Int=True
'Global ExplosionSounds:Int=True
'Global ShowHUD:Int=False
'Global TensionSounds:Int=True
'-----------------------------------------------------------------------------
'Prepare for Launch
'-----------------------------------------------------------------------------
'set the blend to the default the game uses
SetBlend ALPHABLEND
'Start the Intro by fading in
IntroFade.Start()


'-----------------------------------------------------------------------------
'Main Loop
'-----------------------------------------------------------------------------
Repeat

	'If tim < MilliSecs() 
	'	tim = MilliSecs() + 500
	'	FPS = counter*2
	'	counter = 0
	'End If
	'counter:+1
	
	ReturnFromThread=False
	DoEventHooks()
	
	'ResetCollisions()
	'Clear the screen for the mac
	?MacOS
	Cls()
	?
	'Use the aspect module to clear the screen on windows
	?Win32
	AspectCls()
	?
	
	FixedRateLogic.Calc()

 	'Now we do the logic loop ... from 1 not 0!
 	For Local i = 1 To Floor(FixedRateLogic.NumTicks)
  		FixedRateLogic.SetDelta(1)
		PerformCalculations()
		If GameState<>PAUSE GameTicks:+1
 	Next

	'let the other apps have a piece of the computing power cake
	If FullScreen Or VerticalSync=-1
		Delay(1)
	Else
		If VerticalSync=0
			?MacOS
			Delay(3)
			?
			?Win32
			Delay(2)
			?
		End If
	End If
	'Is there a remaining bit in the Numticks float?
 	Local remainder# = FixedRateLogic.NumTicks Mod 1
	If remainder > 0 Then
 		FixedRateLogic.SetDelta(remainder)
		PerformCalculations()
		If GameState<>PAUSE GameTicks:+1
 	EndIf
	
	'Outside of delta-timesync so we can always unpause
	DoPause()
	'CPUTime=MilliSecs()-CPUTime
	
	'GFXTime=MilliSecs()		
	'Draw The stuff you calculated Above (But only when not in a thread)
	If Not ReturnFromThread
		PerformDrawCalls()
		'IngameFont.Draw "KB Alloced: "+GCMemAlloced()/1024,30,140	
	
	Rem
	If Debug
		SetAlpha .6
		IngameFont.Draw "DEBUG BUILD!",5,0
		IngameFont.Draw "DEBUG BUILD!",ScreenWidth-220,0
		IngameFont.Draw "DEBUG BUILD!",5,ScreenHeight-28
		IngameFont.Draw "DEBUG BUILD!",ScreenWidth-220,ScreenHeight-28
		SetAlpha 1
	End If
	
	
	If Debug
		SetScale .5,.5
		'IngameFont.Draw "FPS: "+FPS,30,150
		'IngameFont.Draw "CPU: "+CPUTime,30,180
		'IngameFont.Draw "GPU: "+GFXTime,30,210
		IngameFont.Draw "1. Invincible: "+Player.Invincible,30,240
		IngameFont.Draw "2. Spawnpause: "+SpawnPause,30,270
		IngameFont.Draw "3. Difficulty: "+Difficulty,30,300
		IngameFont.Draw "4. Enemycount: "+Enemycount,30,330
		IngameFont.Draw "5. Extralikeliness: "+Extralikeliness,30,360
		'IngameFont.Draw "6. Fade Volume : "+MusicPlayer.FadeVolume,30,390
		'IngameFont.Draw "7. Force Slowdown.",30,420
		'IngameFont.Draw "8. Logic Focus: "+Logic_LostFocus,30,450
		'IngameFont.Draw "9. Hide This HUD.",30,480
		'IngameFont.Draw "0. Difficulty: "+Difficulty,30,510
		IngameFont.Draw "KB Alloced: "+GCMemAlloced()/1024,30,540	
		SetScale 1,1
	End If
	
	End Rem
	
	'SetScale .5,.5
	'	IngameFont.Draw "KB Alloced: "+GCMemAlloced()/1024,30,540	
	'	IngameFont.Draw "Real  Count: "+CountEnemies(),30,150
	'	IngameFont.Draw "False Count: "+EnemyCount,30,180
	'SetScale 1,1
		'IngameFont.Draw "CPU: "+CPUTime,30,160
		'GFXTime=MilliSecs()-GFXTime
		'IngameFont.Draw "GPU: "+GFXTime,30,190
		'IngameFont.Draw "SP.: "+Difficulty,30,220
		'IngameFont.Draw "INPUT: "+InputTime,30,250
		'IngameFont.Draw "DIFF: "+Difficulty,10,130
		Flip VerticalSync
		'CPUTime=MilliSecs()
	'Screenshot needs to be here as it would just be a black screen before "Flip"
	'If Debug And KeyHit(KEY_M) Then ScreenShot()
		If KeyHit(KEY_F8) And MainMenu.WaitingForInput=False Then ScreenShot()
	'If KeyHit(KEY_MINUS) Score:+500000
	End If
	
	'If we have a request to change graphics update them
	If ReInitGraphics
		InitGraphics(ForceGraphics)
		ReInitGraphics=False
		ForceGraphics=False
	End If
	
			
Until ExitCode

EndGraphics()

OnEnd EndCleanUp

End

'-----------------------------------------------------------------------------
'Function GameInit() sets up the basic game parameters
'-----------------------------------------------------------------------------
Function GameInit(EffectFire:Byte=True)

	'Added for version 1.0.9 should fix the bug
	'Where generating a seed multiple times in a row slows the game down
	If ChangedSeedRecently
		ChangedSeedRecently=False
		TypeDestroy(False)
		GCCollect()
		WarmCaches()
		GCCollect()
	End If
	
	GCCollect()
	
	If JoyCount()<>0
		Local Gomi=JoyInput(InputKey[FIRE_BOMB],True)
		JoyCalibrate(0)
		JoyCalibrate(1)
		JoyCalibrate(2)
		JoyCalibrate(3)
	Else
		If InputMethod>2 Then
			InputMethod=1
			For Local i=0 To 10
				InputKey[i]=InputCache[i,InputMethod]
			Next
		End If
	End If
	
	FlushedOnce=False
	
	WipeOutOnce=MilliSecs()+10500
	
	BombHud.Init()
	
	Corruption.Init()
	
	GridHit.Reset()
	
	Water.Clear()
	
	SpawnQueue.Init()
	
	PowerUp.ShotsAvailable=0
	
	'ParticleManager.AllocateParticles()
	
	Player.Create() 'Create The Players ship & Load Sprite
	
	'Thrust.Init() 'Load Thrust-sprites and initialize
	
	Shot.Init()	'Load Shot sprite and initialize
		
	Flash.Init()
	
	ShockWave.Init()
	
	'Reacher.Init()
	
	Explosion.Init()
	
	'GlowManager.Init()
	
	Player.Reset(EffectFire) 'Reset Values Like Bomb, Shield etc..
	
	'Test to see if the shotghost works anyway as intented
	'ShotGhost.RegetImage()
	
	ScoreRegister.Init()
	
	PowerUp.Init()
	
	Background.Init()
	
	Squared.Init()
	
	Squared.Reset()
	
	'CorruptionEffect.Init()
	
	SpawnEffect.Init()
	
	PlayerBomb.Init()
	
	'ParticleManager.Init()
	
	'SoundLoop.Init()
	
	GUIFadeIn=0
	
	'Game is initialized but we are NOT YET playing
	Player.Alive=False
	
	
	'Start up the fixed rate logic
	FixedRateLogic.ResetFPS()
	FixedRateLogic.CalcMS()
	
	FPSTarget = 200
	FPSCurrent = 200
	FixedRateLogic.Init()
	
	'Load the highscore table, just in case
	HighScore = Highscore.Load(HighScoreFile)  
	
	DoEasterEggOnce=0
	
	EnemiesKilled=0
	
	Multiplier=1
	
	OldMultiplier=1
	
	EnemyCount=0
	
	Difficulty=0
	
	GameTicks=0
	
	ScoreServer.InGame=False
	
	ForceExtra=False
	
	DeathBy=""
	
	NearMissID=""
	
	'Erase Any clicks or keypresses
	FlushMouse()
	FlushKeys()
	FlushJoy(0)
		
	LargestScore=0
	
	'Generate new Obfuscation Mask
	WriteMask=Rand(-14096,6500384)	
	
	'Zero out the Score		
	Score = WriteMask
	
	HighScore.HighLightID=-1
		
	PauseTime=0
	
	PauseSecs=0
	
	CloseEncounters=0
	
	SpawnPause=0
	
	ExtraLikeliness=0
		
	GameOfLife.Clear()
	
	Background.Reset()
		
	'If GAMEMODE=DEFENDER
		'Reacher.Spawn(44,20,300,520)
		'Reacher.Spawn(44,20,300,270)
		'Reacher.Spawn(44,20,750,270)
		'Reacher.Spawn(44,20,750,520)
		
		'DataNode.Spawn(300,520)
		'DataNode.Spawn(300,270)
		'DataNode.Spawn(750,520)
		'DataNode.Spawn(750,270)

	'End If
	
	HudVisibility=0
	HudBombVisibility=0
	HudFrenzyVisibility=0
	
	Frenzy=0
	
	FrenzyMode=0
	
	ScreenShake.Force=0
	
	SpeedGain=RandomGain
	
	'Print RandomGain
	
	LastDifficultyDownGrade=0
	
	MusicPlayer.Resume()
	
	'WarmCaches()
	
	FirstMassSpawn=True
	
	BreakTime=0
	
	'EnhanceChance=0
	
	SpawnQueueFull=False
	
	'Reset Tracking Variables
	Trk_Inv=0
	Trk_Toggle=0
	Trk_Bmb=0
	Trk_Bmb_Up=0
	Trk_Sht=0
	Trk_Sht_Up=0
	Trk_Frnz=0
	Trk_FrnzGn=0
	Trk_Shd=112
	Trk_Str=""
	Trk_NDeath=0
	Trk_Sum=0
	Trk_RedFlag=False
	SpeedCheck.Reset()
	
	LastDifficultyChange=MilliSecs()+2500 
	
	GCCollect()
	
End Function

'-----------------------------------------------------------------------------
'Function PerformCalculations() sums up all logic functions for greater order
'-----------------------------------------------------------------------------
Function PerformCalculations()
		
	'If MilliSecs()-GameClock>2 Then
	'	GameTicks:+1.0
	'	GameClock=MilliSecs()
	'End If
	'InputTime=MilliSecs()
	Select GameState
	
		Case FIRSTSTART
			
			'
	
		Case WAITING
			
			'DoDeath()
	
		Case PLAYING
		
		Case DEAD
		
			'DoDeath()
			
			'ProcessMainMenu()
		
		Case MENU
		
			ProcessMainMenu()
			
		
		Case PAUSE
		
			'ProcessMainMenu()
		
		Case HISCORE
			
			ScoreServer.Update()
			
			'DoDeath()
			
			'ProcessMainMenu()
			
		Case READY
			
			'DoDeath()
			
		Case CREDITS
		
			ProcessMainMenu()
			
		Case VIEWHELP
		
			ProcessHelp()
		
	End Select

	DoFPSLogic()
	
	DoInput()
	
	DoAI()

	DoGame()
	
	If CrossHairType>6
		If GameState<>Pause CycleColors(1*Delta)
	End If
	'DoDialogBoxes()
	'If MilliSecs() Mod 1=0 Then GameTicks:+1
	'GameTicks=MilliSecs()-GameStartTime
	
End Function

'-----------------------------------------------------------------------------
'Function PerformDrawCalls() Redirect Draw-Calls
'-----------------------------------------------------------------------------
Function PerformDrawCalls()
		
		Select GameState
		
		Case WAITING
		
			'DrawBackground()
			
			'DrawDialogBoxes()
			
			'ScreenQuake()
			
			DrawGame()
			
			DrawMenu()
			
			DoMusic()
			
			DoDeath()
			
			
		
		Case PLAYING
			
			'DrawBackground()
			
			'ScreenQuake()
				
			DrawGame()
						
			DrawHUD()
			
			DoMusic()
			
			
			
		Case DEAD
			
			'DrawBackground()
			
			'DrawDialogBoxes()
			
			'ScreenQuake()
			
			DrawGame()
			
			DrawMenu()
			
			DoMusic()
	
			DoDeath()
			
		Case FIRSTSTART
						
			DrawMenu()
			
			'DrawDialogBoxes()
			
			DrawLogos()
		
		Case MENU
			
			'If MenuFade.Test()=True MenuFade.ReDraw()
			
			DoMusic()
		
			DrawGame()
		
			'DrawBackground()
						
			DrawMenu()
			
			DrawMainMenu()
			
			'DrawDialogBoxes()
		
		Case CREDITS
			
			DrawGame()
		
			'DrawBackground()
						
			DrawMenu()
			
			DrawMainMenu()
			
			DoMusic()
			
		Case PAUSE
			
			'DrawBackground()
				
			'ScreenQuake()
			
			DrawGame()
			
			DrawHUD()
			
			DrawMenu()
			
			DoMusic()
		
		
		Case HISCORE
			
			'DrawBackground()
			'ScreenQuake()
						
			DrawGame()
		
			DrawMenu()
			
			'DrawDialogBoxes()
				
			DoMusic()
			
			DoDeath()
			
		Case READY
			
			If ReadyTimer=0 Then ReadyTimer=MilliSecs()
			If ReadyTimer<>0 And MilliSecs()-ReadyTimer>1000 Then
				'DoDeath()
				GameState=PLAYING
				PlaySecs=MilliSecs()
				ReadyTimer=0
			End If
			
			'DrawBackground()
			
			'DrawDialogBoxes()
			
			DrawGame()
			
			DrawHUD()
			
			DrawMenu()
			
		Case VIEWHELP
		
			DrawGame()
			
			DrawMenu()
			
			DrawHelp()
			
			DoMusic()
			
	End Select
	
	If InputMethod=1 Or InputMethod=2
		If GameState<>FIRSTSTART DrawCursor()
	ElseIf GameState<>Playing And GameState<>Ready
		If GameState<>FIRSTSTART DrawCursor()
	End If
	
	SpeedCheck.Update()
	
End Function

'-----------------------------------------------------------------------------
'Function DoInput() Performs generic input Polling
'-----------------------------------------------------------------------------
Function DoInput()
	
	TrackMouse()
	
	'If KeyHit(KEY_Z) MoveMouse(1000,1000)
	
	?MacOS
	If KeyDown(KEY_LSYS) Or KeyDown(KEY_RSYS) And KeyDown(KEY_Q) Then ExitCode=True
	?
	
	?Win32
	If KeyDown(KEY_LALT) Or KeyDown(KEY_RALT) And KeyDown(KEY_F4) Then ExitCode=True
	?
	'DebugKeys()
	'If KeyHit(Key_0) Then FullScreenGlow=1-FullScreenGlow
	
	If GameState=Waiting And HighScore.HighlightID=0 And TYPING=False
		If KeyHit(KEY_S)
			GameMode=VIEWRANK
			GameState=HISCORE
			ConnectScoreServer=True
			ScoreServer.NotifyUser=False
			ScoreServer.Monthly=False
			ScoreServer.InGame=True
		End If
	End If
	
	If Not MainMenu.WaitingForInput
		
		If TYPING=False And KeyHit(KEY_F7)
			AutoFire=1-AutoFire
		End If
		
		If TYPING=False And KeyHit(KEY_F10)
			If FullScreen=0 Then
				If GraphicsModeExists(RealWidth,RealHeight,32)
					FullScreen=1
					If GameState=PLAYING Or GameState=READY TogglePause()
					ReInitGraphics=True
					'InitGraphics()
				Else
					If GameState=PLAYING Or GameState=READY TogglePause()
					Notify("The currently set windowed resolution is not~nsupported in full-screen mode.",True)
					ReInitGraphics=True
					'InitGraphics()
				End If
				
			Else
				FullScreen=0
				If GameState=PLAYING Or GameState=READY TogglePause()
				ReInitGraphics=True
				'InitGraphics()
			EndIf
		End If
		
		If TYPING=False And KeyHit(Key_F11) Then
			SoundMute=1-SoundMute
		End If
	
	End If

	If KeyHit (KEY_ESCAPE) Then
		GCCollect()
		If ConnectScoreServer
			ConnectScoreServer=False
			LockMutex ThreadMutex
			AbortThread=True
			UnlockMutex ThreadMutex
		End If
		ToolTip=""
		ScreenShake.Force=0
		MusicPlayer.Resume()
		If GameState=MENU Then
			'If hit ESC while setting up keyboard
			If MainMenu.WaitingForInput
				'Restore the previous key
				InputKey[MainMenu.PreviousKey]=MainMenu.PreviousScancode
				'And release the cursor
				MainMenu.WaitingForInput=False
				'Update Key Caches
				InputCache[MainMenu.PreviousKey,InputMethod]=InputKey[MainMenu.PreviousKey]
				'Update the Menu to reflect the changes
				MainMenu.UpdateOptionStates()
				FlushKeys()
				FlushMouse()
				Return
			ElseIf MainMenu.WaitingForInput=False And MainMenu.OptionLevel>1
				'We are anywhere elese in the menu and go back to main level
				PlaySoundBetter Sound_Menu_No,ScreenWidth/2,ScreenHeight/2,False,False
				If MainMenu.OptionLevel=5 And MainMenu.GraphicsError
					MainMenu.GraphicsError=False
					MainMenu.OptionLevel=5
					FlushKeys()
				End If
				If MainMenu.OptionLevel=9 And MainMenu.GraphicsError
					MainMenu.GraphicsError=False
					MainMenu.OptionLevel=9
					FlushKeys()
				Else
					MainMenu.OptionLevel=1
				End If
				FlushKeys()
				FlushMouse()
				Return
			End If
			If MainMenu.OptionLevel=1 ExitCode=True
		Else
			PlaySoundBetter Sound_Menu_No,ScreenWidth/2,ScreenHeight/2,True,False
			If IntroStep<5 Then
				IntroFade.ConvertToFadeOut()
				IntroFade.FadeStart=True
				IntroStep=5
				'MenuFade.ConvertToFadeOut()
				MenuFade.FadeStart=True
				GameState=MENU
				PresentsFade.ConvertToFadeOut()
				FlushMouse()
				FlushKeys()
			Else
				GameState=MENU
				Player.Alive=False
				Player.Dying=False
				
				'Start up the fixed rate logic
				FixedRateLogic.ResetFPS()
				FixedRateLogic.CalcMS()
				Score=WriteMask
				
				FPSTarget = 200
				FPSCurrent = 200
				FixedRateLogic.Init()
				FlushMouse()
				FlushKeys()
				
			End If
		End If
	End If
	
End Function
'-----------------------------------------------------------------------------
'Function DoMusic() plays the background music for the game
'-----------------------------------------------------------------------------
Function DoMusic()
	
	If IntroStep<5 And PresentsFade.Test() Return
	MusicPlayer.UpdateAll()
	
End Function


'-----------------------------------------------------------------------------
'Function DrawMenu() draws the Menu and Option screens
'-----------------------------------------------------------------------------
Function DrawMenu()

		Select GameState
			
			
			Case DEAD
				'SetImageFont BoldFont
				SetTransform 0,1,1
				
				Local temp:Int
				temp = (DeathSecs-PlaySecs)/1000

				'Dont draw when getting player name etc
				If Player.Dying Or HighScore.IsHighScore((Score-WriteMask)+OpenGLHash) Return

				Select GameMode
					
					
					Case ARCADE

						SetOrigin 0,0

						DarkenScreen(GUIFadeIn/2)
						HighScore.Render(ScreenWidth/2,ScreenHeight/2-210)
						DrawTextCentered "Game Over! You scored "+ScoreDotted(Score-WriteMask)+" points.",ScreenWidth/2,ScreenHeight/2+125
						SetColor 195,195,195
						'DrawTextCentered "Your best kill was worth "+LargestScore+ " points.",ScreenWidth/2,ScreenHeight/2+135
						If EnemiesKilled<>1
							DrawTextCentered "You decompiled "+EnemiesKilled+" invaders.",ScreenWidth/2,ScreenHeight/2+170
						Else
							DrawTextCentered"You decompiled one lonely invader, how did that happen?",ScreenWidth/2,ScreenHeight/2+170
						End If
						If Upper(Left(DeathBy,1))="E" Or Upper(Left(DeathBy,1))="A" Or Upper(Left(DeathBy,1))="U" Or Upper(Left(DeathBy,1))="O" Then
							DrawTextCentered "An "+DeathBy+" killed you.",ScreenWidth/2,ScreenHeight/2+200
						Else
							DrawTextCentered "A "+DeathBy+" killed you.",ScreenWidth/2,ScreenHeight/2+200
						End If
						SetColor 255,255,255
					Default
						DarkenScreen(GUIFadeIn/2)
						'SetScale 1,1
						DoubleBoldFont.Draw "GAME OVER",ScreenWidth/2,ScreenHeight/2-140,True
						DrawTextCentered "You scored "+ScoreDotted(Score-WriteMask)+" points.",ScreenWidth/2,ScreenHeight/2-40
						SetColor 195,195,195
						If EnemiesKilled<>1
							DrawTextCentered "You decompiled "+EnemiesKilled+" invaders.",ScreenWidth/2,ScreenHeight/2+135
						Else
							DrawTextCentered "You decompiled one lonely invader, how did that happen?",ScreenWidth/2,ScreenHeight/2+135
						End If
						If Upper(Left(DeathBy,1))="E" Or Upper(Left(DeathBy,1))="A" Or Upper(Left(DeathBy,1))="U" Or Upper(Left(DeathBy,1))="O" Then
							DrawTextCentered "An "+DeathBy+" killed you.",ScreenWidth/2,ScreenHeight/2+165
						Else
							DrawTextCentered "A "+DeathBy+" killed you.",ScreenWidth/2,ScreenHeight/2+165
						End If
						SetColor 255,255,255
				End Select
	
				'SetAlpha (GUIFadeIn/2)
				SetColor 125,125,125
				If InputMethod<3
					DrawTextCentered "Hit "+KeyNames[InputKey[FIRE_BOMB]]+" to retry, or ESC For Menu!",ScreenWidth/2,ScreenHeight/2+255
				Else
					DrawTextCentered "Hit Bomb Button to retry, or ESC For Menu!",ScreenWidth/2,ScreenHeight/2+255
				End If
				'DrawTextCentered "Hit Spacebar to retry, or ESC for Menu!",ScreenWidth/2,ScreenHeight/2+225
				SetAlpha (1)	
				
				
				
			Case WAITING
				'SetImageFont BoldFont
				SetTransform 0,1,1
				DarkenScreen(GUIFadeIn/2)
				SetAlpha (GuiFadeIn)
				'DrawImage GameLogo,ScreenWidth/2,150
				SetColor 255,255,255
				
				If HighScore.HighlightID=0 Then
						DrawTextCentered "NEW PERSONAL BEST SCORE!",ScreenWidth/2,ScreenHeight/2+125
						SetColor 180,180,180
						DrawTextCentered "PRESS THE 'S' KEY TO SUBMIT THIS SCORE ON-LINE.",ScreenWidth/2,ScreenHeight/2+155
				End If
				SetColor 125,125,125
				'SetAlpha (GuiFadeIn/2)
				'DrawTextCentered "INVADERS: CORRUPTION",ScreenWidth/2,ScreenHeight/2+105
				DrawTextCentered "Hit "+KeyNames[InputKey[FIRE_BOMB]]+" to retry, or ESC For Menu!",ScreenWidth/2,ScreenHeight/2+255

				
				HighScore.Render(ScreenWidth/2,ScreenHeight/2-210)
				
			Case HISCORE
				'SetImageFont BoldFont
				SetRotation (0)
				If ViewOnline=False
					HighScore.Render(ScreenWidth/2,ScreenHeight/2-210)
					'SetAlpha (.45)
				
					'DrawTextCentered "Hit ESC for Menu!",ScreenWidth/2,ScreenHeight/2+210
					'SetAlpha (1)	
				
				Else
					If GameMode=VIEWSCORE
						HighScore.Render(ScreenWidth/2,ScreenHeight/2-210)
					ElseIf GameMode=VIEWRANK
						ScoreServer.Render(ScreenWidth/2,ScreenHeight/2-320)
					ElseIf GameMode=VIEWONLINE
						ScoreServer.Render(ScreenWidth/2,ScreenHeight/2-320,False)
					Else
						HighScore.Render(ScreenWidth/2,ScreenHeight/2-210)
					End If
				End If
				
			Case READY
				'SetImageFont DoubleBoldFont
				SetTransform 0,1,1

				SetAlpha 7.66+(Float(ReadyTimer)-MilliSecs())/130
				'Print 7.67+(Float(ReadyTimer)-MilliSecs())/130

				DoubleBoldFont.Draw "GET READY!",ScreenWidth/2,ScreenHeight/2-30,True
				
				SetAlpha 1				
				
			Case PAUSE
				'SetImageFont DoubleBoldFont
				SetAlpha 1
				SetTransform 0,1,1
				DoubleBoldFont.Draw  "PAUSED",ScreenWidth/2,ScreenHeight/2-30,True
				SetAlpha 0.65
				IngameFont.Draw "Press 'ESC' or 'P' to resume.",ScreenWidth/2,ScreenHeight/2+20,True
				SetAlpha 1
		End Select

	
End Function
Rem
Global CurrentGlow
Global MaxGlow
Global CurrentParticles
Global MaxParticles
Global MaxBlur
Global CurrentBlur
End Rem
Global TriedOnce:Byte=False
'Global GetPeak:Int
'-----------------------------------------------------------------------------
'Function DrawHUD() Draws the heads up display during gameplay
'-----------------------------------------------------------------------------
Function DrawHUD()
	
	SetOrigin 0,0

	If GameMode<>ARCADE Return	'We don't need a HUD for Freeplay & Twitter Mode
	
	If MilliSecs()-HudTick>=15
		If Not Player.Alive And HudVisibility<1 And MilliSecs()-DeathSecs>=275
			HudVisibility=Tween(HudVisibility,1,0.05)
		End If
		
		If Player.Alive And Player.X<275 And Player.Y<95 And HudVisibility<.7
			HudVisibility=Tween(HudVisibility,0.7,0.07)
		ElseIf HudVisibility>0 And Player.Alive
			HudVisibility=Tween(HudVisibility,0,0.05)
		End If
		
		If Player.Alive And Player.X>FieldWidth-24-40*(Player.HasBomb-Player.MaskBomb) And Player.Y>FieldHeight-73 And HudBombVisibility<.7
			HudBombVisibility=Tween(HudBombVisibility,0.7,0.07)
		ElseIf HudBombVisibility>0 And Player.Alive
			HudBombVisibility=Tween(HudBombVisibility,0,0.05)
		End If
		
		If Player.Alive And Player.X>FieldWidth-240 And Player.Y<70 And HudFrenzyVisibility<.7
			HudFrenzyVisibility=Tween(HudFrenzyVisibility,0.7,0.07)
		ElseIf HudFrenzyVisibility>0 And Player.Alive
			HudFrenzyVisibility=Tween(HudFrenzyVisibility,0,0.05)
		End If
		
		If Not FrenzyMode
			If Not FrenzyMode And Frenzy>=16 And EnemyCount<28
				If MilliSecs()-PulseTime>500
					FrenzyG=Tween(FrenzyG,128,0.1)
					FrenzyB=Tween(FrenzyB,0,0.1)
					If FrenzyB<=0.5 PulseTime=MilliSecs()
				Else
					FrenzyG=Tween(FrenzyG,255,0.1)
					FrenzyB=Tween(FrenzyB,255,0.1)
				End If
			Else
				FrenzyG=Tween(FrenzyG,255,0.1)
				FrenzyB=Tween(FrenzyB,255,0.1)
			End If
		Else
			FrenzyG=Tween(FrenzyG,128,0.05)
			FrenzyB=Tween(FrenzyB,0,0.05)
		End If
		HUDTick=MilliSecs()
	End If
	'SetImageFont ImageFont
	SetTransform 0,1,1
	SetAlpha 1-(HudVisibility*1.15)
	SetBlend ALPHABLEND
	'DrawText "MouseX : "+MouseX(),420,10
	'DrawText "MouseY : "+MouseY(),420,30
	'DrawText "Application is in suspend: "+AppSuspended(),50,50
	'DrawText
	'IngameFont.Draw "ViewPortX: "+ViewPortX,30,90
	'IngameFont.Draw "Water: "+Water.DrawTimeFinal+" / "+Water.UpdateTimeFinal,30,160
	'f Not Player.Alive temp = 0
	
	If BestScore-OpenGLHash>Score-WriteMask
		ScoreFont.Draw PadWithZeros(Score-WriteMask,8),27,27
		SetScale .6,.6
		SetAlpha .8-HudVisibility
		ScoreFont.Draw "HI",27,64
		scorefont.Draw PadWithZeros(BestScore-OpenGLHash,8),65,64
		SetScale 1,1
		SetAlpha 1-HudVisibility
		'SetColor 210,210,210
		'ScoreFont.Draw "/",ScoreFont.StringWidth(PadWithZeros(Score-WriteMask,8))+35,27
		'SetColor 255,255,255
		'ScoreFont.Draw Multiplier+"x",ScoreFont.StringWidth(PadWithZeros(Score-WriteMask,8))+65,27
	Else
		ScoreFont.Draw "HI",ScoreFont.StringWidth(PadWithZeros(Score-WriteMask,8))+40,27
		ScoreFont.Draw PadWithZeros(Score-WriteMask,8),27,27
		'SetColor 210,210,210
		'ScoreFont.Draw "/",ScoreFont.StringWidth(PadWithZeros(Score-WriteMask,8))+95,27
		'SetColor 255,255,255
		'ScoreFont.Draw Multiplier+"x",ScoreFont.StringWidth(PadWithZeros(Score-WriteMask,8))+125,27
		If TriedOnce=False
			If Rand(0,100)<3 And Score-WriteMask>1750000 MusicPlayer.Request("hiscore-bop")
			TriedOnce=True
		End If
		
	End If
	
	'Debug counts
	Rem
	If CurrentBlur>MaxBlur MaxBlur=CurrentBlur
	If CurrentParticles>MaxParticles MaxParticles=CurrentParticles
	If CurrentGlow>MaxGlow MaxGlow=CurrentGlow
	End Rem
	If Not Player.Alive And MilliSecs()-DeathSecs>=275
	
	Else
		SetAlpha 1-(HudFrenzyVisibility*1.15)
	End If
	
	SetScale 3,3
	SetColor 255,FrenzyG,FrenzyB
	DrawImage FrenzyMeter,FieldWidth-240,33
	DrawSubImageRect FrenzyBar,FieldWidth-240,33,1+FrenzyGraph*4,7,0,0,1+FrenzyGraph*4,7
	SetScale 1,1
	SetColor 255,255,255
	'IngameFont.Draw "DIF: "+Difficulty,30,60
	'IngameFont.Draw "Ticks: "+GameTicks/(MilliSecs()-PlaySecs),30,90
	'SetScale .5,.5
	'SetAlpha .75
	'ScoreFont.DrawAligned "HI-"+PadWithZeros(Score,8),27,65
	'IngameFont.Draw "Divider: "+Difficulty,27,60
	'IngameFont.Draw "DIF: "+floatround(Difficulty,2),30,60
	'IngameFont.Draw "Tick Nr: "+GameTicks,30,90
	'IngameFont.Draw "Logic: "+FixedRateLogic.GetDisplay(),30,90
	'IngameFont.Draw "Mem  : "+GCMemAlloced()/1024,30,120
	'IngameFont.Draw "FPS: "+FPS,30,90
	'IngameFont.Draw "Frametarget: "+DisplayMe,30,120
	'FixedRateLogic.Display(30,60)
	'If ShotGhost.ActiveElements>GetPeak Then GetPeak=ShotGhost.ActiveElements
	'DrawText "MEM: "+FloatRound(Float(GCMemAlloced())/(1024*1024),2),30,90
	'DrawText "SHOT P: "+GlowManager.ActiveElements,30,110
	'DrawText "SHOT C: "+ShotGhost.ActiveElements,30,120
	'DrawText "PART: "+(Player.HasBounce-MilliSecs()),30,150

	'DrawText "Toggle (m) - InputMethod: "+InputMethod,50,70
	'DrawText "Toggle (s) - Slow Motion: "+SlowMo,50,90
	'SetColor (255,255,255)
	'If Not Player.Alive And MilliSecs()-DeathSecs>=275
	
	'Else
	'	SetAlpha 1-(HudBombVisibility*1.15)
	'End If
	BombHUD.DrawAll()
	'If Player.HasBomb>0
		
	'	SetScale 1.25,1.25
	'	For Local i=1 To Player.HasBomb
	'		DrawImage BombIcon,ScreenWidth-3-40*i,ScreenHeight-43
	'		'ScoreFont.Draw "B",ScreenWidth-9-43*i,ScreenHeight-62
	'	Next
	'End If
	
	SetAlpha 1
	
End Function

'-----------------------------------------------------------------------------
'Function DoDeath() handles your afterlife. You believe in afterlife, do you?
'-----------------------------------------------------------------------------
Function DoDeath()
			
	If Not Player.Alive Then 
		
		SpeedCheck.Stop()
		
		If GameMode<>VIEWSCORE And GameMode<>VIEWRANK And GameMode<>VIEWONLINE MusicPlayer.Request("gameover")
		
		If MilliSecs()-HUDTick>=15
			If GUIFadeIn<1
				GUIFadeIn=Tween(GUIFadeIn,1,0.02)
			End If
			If FlushedOnce=False
				FlushMouse()
				FlushKeys()
				If JoyCount()>0 FlushJoy()
				FlushedOnce=True
			End If
			HUDTick=MilliSecs()
		End If				
		If GameState<>HISCORE And Player.Dying=False And GuiFadeIn>.55
				
			If InputKey[FIRE_BOMB]>3 And InputKey[FIRE_BOMB]<200
				If KeyHit(InputKey[FIRE_BOMB])
				
				TypeDestroy(False)
				
				'Reset All Variables
				GameInit()
				
				'The Player is alive Again
				Player.Alive=True
				
				'Gamestate is Getting Ready
				GameState=READY
				
				PlaySoundBetter Sound_Game_Start,FieldWidth/2,FieldHeight/2,False,False
					
				End If
			ElseIf InputKey[FIRE_BOMB]<=3
				If MouseHit(InputKey[FIRE_BOMB])
				
				TypeDestroy(False)
				
				'Reset All Variables
				GameInit()
				
				'The Player is alive Again
				Player.Alive=True
				
				'Gamestate is Getting Ready
				GameState=READY
				
				PlaySoundBetter Sound_Game_Start, FieldWidth/2,FieldHeight/2,False,False
				
				End If
			Else
				If JoyInput(InputKey[FIRE_BOMB],True)
				
				TypeDestroy(False)
				
				'Reset All Variables
				GameInit()
				
				'The Player is alive Again
				Player.Alive=True
				
				'Gamestate is Getting Ready
				GameState=READY
				
				PlaySoundBetter Sound_Game_Start, FieldWidth/2,FieldHeight/2,False,False
				
				End If
			End If
		End If
			
	End If
	
	Local IsHighScore = False	
	
	If GameMode=ARCADE Then IsHighScore = HighScore.IsHighScore((Score-WriteMask)+OpenGLHash)
	
	If IsHighScore And GameMode=ARCADE Then GameState=HISCORE
						
		If IsHighScore = True Then
			'Flush the keys one last time before typing
			If Typing=False
				FlushKeys()
			End If
			
			SetOrigin 0,0
			'DarkenScreen(GUIFadeIn/5)
			'Print TickAverage
			Trk_Sum=Trk_Inv+Trk_Bmb+Trk_Bmb_Up+Trk_Sht+Trk_Sht_Up+Trk_Frnz+EnemiesKilled+Trk_Diff+MultiPlier+Trk_FrnzGn+Trk_NDeath+SpeedCheck.OffsetAverage+SpeedCheck.MeasurePoints+SpeedCheck.Low_Infractions+SpeedCheck.Hi_Infractions
			Trk_Sum:-9374
			Trk_Str=String(Trk_Inv)+"/"+String(Trk_Bmb)+"/"+String(Trk_Bmb_up)+"/"+String(Trk_Sht)+"/"+String(Trk_Sht_Up)+"/"+String(Trk_Frnz)+"/"+String(EnemiesKilled)+"/"+String(Trk_Diff)+"/"+String(Multiplier)+"/586/"+String(Trk_Shd)+"/"+String(TickAverage)+"/"+String(Trk_FrnzGn)+"/"+String(Trk_NDeath)+"/"+Upper(DeathBy)+"/"+String(Trk_Sum)
			Trk_Str:+"/"+String(SpeedCheck.Hi_Infractions)+"/"+String(SpeedCheck.Low_Infractions)+"/"+String(SpeedCheck.MeasurePoints)+"/"+String(SpeedCheck.OffsetAverage)+"/"+FloatRound(SeedDifficultyJudge,1)+"/"+String(Trk_RedFlag)			
			
			?MacOS
				Trk_Str:+"/MAC"
			?
			?Win32
				Trk_Str:+"/WIN"
			?
			'Print Trk_Str
			'Print Trk_Str
			TYPING=True
			'SetImageFont BoldFont
			SetScale(1,1)
			SetRotation(0)
			DarkenScreen(GUIFadeIn/2)
			SetAlpha(GUIFadeIn)
			DrawTextCentered "New Highscore: "+ScoreDotted((Score-WriteMask))+"!",ScreenWidth/2,ScreenHeight/2+115
			'DrawTextCentered "Your best kill was worth "+LargestScore+ " points.",ScreenWidth/2,ScreenHeight/2+215
			SetColor 195,195,195
			DrawTextCentered "Enter your name, network defender:",ScreenWidth/2,ScreenHeight/2+145
			If EnemiesKilled<>1
				DrawTextCentered "You decompiled "+EnemiesKilled+" invaders.",ScreenWidth/2,ScreenHeight/2+240
			Else
				DrawTextCentered "You decompiled one lonely invader, how did that happen?",ScreenWidth/2,ScreenHeight/2+240
			End If
			If Upper(Left(DeathBy,1))="E" Or Upper(Left(DeathBy,1))="A" Or Upper(Left(DeathBy,1))="U" Or Upper(Left(DeathBy,1))="O" Then
				DrawTextCentered "An "+DeathBy+" killed you.",ScreenWidth/2,ScreenHeight/2+270
			Else
				DrawTextCentered "A "+DeathBy+" killed you.",ScreenWidth/2,ScreenHeight/2+270
			End If
			SetColor 255,255,255
			If GUIFadeIn>0.1 GetInput(ScreenWidth/2,ScreenHeight/2+190,PlayerName)
		Else
			TYPING=False
			End If 
				
		'DrawTextCentered "Press ENTER to Retry",ScreenWidth/2,ScreenHeight/2
				
		If KeyHit(KEY_ENTER) And Gamestate=HISCORE
			
			FlushMouse()
			FlushKeys()
			FlushJoy()
		
			Local TrailingSpaces=True
			Local LeadingSpaces=True
			
			While TrailingSpaces
				TrailingSpaces=False
				If Right(PlayerName,1)=" " Then
					DebugLog "Name Has Trailing Space!"
					PlayerName = Mid(PlayerName,0,Len(PlayerName))
					TrailingSpaces=True
				End If
			Wend
			
			While LeadingSpaces
				LeadingSpaces=False
				If Left(PlayerName,1)=" " Then
					DebugLog "Name Has Leading Space!"
					PlayerName = Right(PlayerName,Len(PlayerName)-1)
					LeadingSpaces=True
				End If
			Wend
			
			PlayerName=SanitizeInput(PlayerName,21)
			
			If PlayerName="" Then PlayerName="ANONYMOUS PLAYER"
			
			'Print "Player Name = " + PlayerName
			If IsHighScore = True Then UpdateHighScores()

			GameState = WAITING
			
			IsHighScore = False
			
			Score = WriteMask
			
			FlushKeys()

		End If			
		
End Function

Function UpdateHighScores()

	HighScore.Add(Score-WriteMask+OpenGLHash,PlayerName,Seed,Int((DeathSecs-PlaySecs)/1000),Trk_Str) 
	HighScore.Save(HighScoreFile)

End Function
'-----------------------------------------------------------------------------
'Function DoAI() handles the artifical intelligence of the "Spawn Director"
'-----------------------------------------------------------------------------
Function DoAI()
	'Chance for additional extras spawning preventing periods of "draught"
	Local EnhanceChance:Int=0
	Local Rounds:Int=GameTicks
	Local ForceSpawn:Byte
	Local ScoreOffset:Float
	
	'Count the amount of enemies onscreen
	EnemyCount=CountEnemies()

 	'Widescreen has slightly more enemies
	If WideScreen And EnemyCount>5 And Score-WriteMask>35000 Then EnemyCount:-4
	'Make difficulty seeds more difficult
	If SeedDifficultyJudge>73 And EnemyCount>7 Then EnemyCount:-5
	'On the Corollary make easy seeds less difficult
	If SeedDifficultyJudge<31 And EnemyCount>5 Then EnemyCount:+6
	
	If GameState=Playing And PowerUp.LastSpawn<>-1
		Local PowerUpTime:Int=MilliSecs()-PowerUp.LastSpawn

		If PowerUpTime<6250
			EnhanceChance=-36
		ElseIf PowerUpTime<9500
			EnhanceChance=-28
		ElseIf PowerUpTime>10500
			EnhanceChance=0
		ElseIf PowerUpTime>17500
			EnhanceChance=7
		ElseIf PowerUpTime>25000
			EnhanceChance=10
		ElseIf PowerUpTime>35000
			EnhanceChance=13
		ElseIf PowerUpTime>50000
			EnhanceChance=16
		ElseIf PowerUpTime>60000
			EnhanceChance=19
		End If
	End If
	
	If GameState=FIRSTSTART Return
	
	If SeedJumble(Seed)="LIAP@ELLI" And GameState=PLAYING And DoEasterEggOnce=False
		SpawnQueue.Empty()
		SpawnQueue.Add(SCATTER,AASTEROID,16,100)
		SpawnPause=GameTicks+8000
		DoEasterEggOnce=True
	End If
	
	If ScoreMultiplier<=.75 Then ScoreOffset=.95
	If ScoreMultiplier<=.50 Then ScoreOffset=.75
	If ScoreMultiplier<=.25 Then ScoreOffset=.5
	If ScoreMultiplier<=.125 Then ScoreOffset=.3
	If ScoreMultiplier>=1 Then ScoreOffset=1
	If ScoreMultiplier>=1.4 Then ScoreOffset=1.125
	
	'Print ScoreOffset
	
	'If MouseHit(3) Then 
	'If KeyHit(KEY_Z) Then Player.HasSlowmotion=MilliSecs()+10000 '; Player.HasBounce=MilliSecs()+10000000
	'If KeyHit(KEY_X) Then Player.HasShot:+1
	'If KeyHit(KEY_C) Then SpawnQueue.Add(SCATTER,THIEFBOT,1,900+SpawnInterval) 
	'If KeyHit(KEY_X) Then SpawnQueue.Add(SCATTER,PANICER,23,900+SpawnInterval) 
	'If KeyHit(KEY_V) Then SpawnQueue.Add(SURROUND,AASTEROID,23,900+SpawnInterval) 
	
	'If KeyHit(Key_C) Then ScreenShake.Force:+10'Frenzy:+1
	'If KeyHit (KEY_V) Then For Local i=1 To 100; PowerUp.Spawn(Rand(0,FieldWidth),Rand(0,FieldHeight),Powerup.Immolation,True); Next '; Player.HasBomb:+1; Player.HasBounce=MilliSecs()+4000
	'If KeyHit(KEY_C) Then Difficulty=18; Score=WriteMask+9000000; 'Player.HasShot=Player.Shotmask+2
	'If KeyHit(KEY_X) Then SpawnPause=0; CloseEncounters=-100;BreakTime=0
	'Return

	If Score-WriteMask<35000*ScoreOffset
		
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=1+EnhanceChance; SpawnPause=0
		
		If CloseEncounters>8 And EnemyCount>25 ExtraLikeliness=5+EnhanceChance	
		
		If CloseEncounters>16 And EnemyCount>30 ExtraLikeliness=6+EnhanceChance
				
		If CloseEncounters>25 And EnemyCount>30
			SpawnPause=3850+Rounds '4500
			BreakTime:+3850
			CloseEncounters:-16
			LastDifficultyChange:+1450
			'SoundLoop.FadeOut(LOOP_TENSION)
		End If
		
		If CloseEncounters>32 And EnemyCount>35 ExtraLikeliness=11+EnhanceChance
		
		If CloseEncounters<-10 And EnemyCount<34 ExtraLikeliness=-5+EnhanceChance
		
		If EnemyCount>40 And SpawnPause=0 SpawnPause=2950+Rounds;SpawnQueueFull=True '2750
		
		If CloseEncounters> 11 
			SpawnInterval=240
		Else
			SpawnInterval=180
		End If
		
		If Difficulty>4 Then Difficulty=4
		
	ElseIf Score-WriteMask>35000*ScoreOffset And Score-WriteMask<275000*ScoreOffset
	
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=1+EnhanceChance; SpawnPause=0
		
		If CloseEncounters>8 And EnemyCount>30 ExtraLikeliness=4+EnhanceChance	
		
		If CloseEncounters>16 And EnemyCount>40 ExtraLikeliness=5+EnhanceChance
		
		If CloseEncounters>28 And EnemyCount>35
			SpawnPause=3800+Rounds '4250
			BreakTime:+3800
			CloseEncounters:-17
			LastDifficultyChange:+1650
			'SoundLoop.FadeOut(LOOP_TENSION)
			If Difficulty>8 Difficulty=8
		End If
		
		If CloseEncounters>35 And EnemyCount>65 ExtraLikeliness=10+EnhanceChance
		
		If CloseEncounters<-10 And EnemyCount<45 ExtraLikeliness=-6+EnhanceChance
		
		If EnemyCount>42 And SpawnPause=0 SpawnPause=2750+Rounds;SpawnQueueFull=True '2050
		
		If CloseEncounters> 12 
			SpawnInterval=220
		Else
			SpawnInterval=170
		End If
		If Difficulty>6 Then Difficulty=6
		
	ElseIf Score-WriteMask>275000*ScoreOffset And Score-WriteMask<645000*ScoreOffset
	
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=0+EnhanceChance; SpawnPause=0
		
		If CloseEncounters>15 And EnemyCount>30 ExtraLikeliness=3+EnhanceChance	
		
		If CloseEncounters>25 And EnemyCount>40 ExtraLikeliness=4+EnhanceChance
		
		If CloseEncounters>30 And EnemyCount>42
			SpawnPause=4625+Rounds '3400
			BreakTime:+4625
			CloseEncounters:-20
			LastDifficultyChange:+1550
			'SoundLoop.FadeOut(LOOP_TENSION)
		End If
		
		If CloseEncounters>40 And EnemyCount>55 ExtraLikeliness=10+EnhanceChance
		
		If CloseEncounters<-10 And EnemyCount<60 ExtraLikeliness=-9+EnhanceChance
		
		If EnemyCount>46 And SpawnPause=0 SpawnPause=2705+Rounds;SpawnQueueFull=True '1600
		
		If CloseEncounters> 15 
			SpawnInterval=190
		Else
			SpawnInterval=140
		End If
	
	ElseIf Score-WriteMask>645000*ScoreOffset And Score-WriteMask<1550000*ScoreOffset
		
		If Difficulty<7 Then
			Difficulty=7 
			LastDifficultyChange=MilliSecs()
		End If
		
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=0+EnhanceChance; SpawnPause=0
		
		If CloseEncounters>18 And EnemyCount>30 ExtraLikeliness=1+EnhanceChance	
		
		If CloseEncounters>29 And EnemyCount>40 ExtraLikeliness=3+EnhanceChance
		
		If CloseEncounters>35 And EnemyCount>47
			SpawnPause=4500+Rounds
			BreakTime:+4500
			CloseEncounters:-27
			LastDifficultyChange:+1350
			'SoundLoop.FadeOut(LOOP_TENSION)
		End If
		
		If EnemyCount>50 And SpawnPause=0 SpawnPause=2650+Rounds;SpawnQueueFull=True '1600
		
		If CloseEncounters>45 And EnemyCount>60 ExtraLikeliness=8+EnhanceChance
		
		If CloseEncounters<-8 And EnemyCount<68 ExtraLikeliness=-10+EnhanceChance
		
		If CloseEncounters>17 
			SpawnInterval=190
		Else
			SpawnInterval=120
		End If
	
	ElseIf Score-WriteMask>155000*ScoreOffset And Score-WriteMask<2100000*ScoreOffset
	
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=0+EnhanceChance; SpawnPause=0
		
		If CloseEncounters>19 And EnemyCount>35 ExtraLikeliness=1+EnhanceChance
		
		If CloseEncounters>29 And EnemyCount>40 ExtraLikeliness=2+EnhanceChance
		
		If CloseEncounters>40 And EnemyCount>50
			SpawnPause=4200+Rounds
			BreakTime:+4200
			CloseEncounters:-32
			LastDifficultyChange:+1150
			'SoundLoop.FadeOut(LOOP_TENSION)
		End If
		
		If EnemyCount>54 And SpawnPause=0 SpawnPause=2350+Rounds;SpawnQueueFull=True '1600
		
		If CloseEncounters>45 And EnemyCount>65 ExtraLikeliness=7+EnhanceChance
		
		If CloseEncounters<-8 And EnemyCount<70 ExtraLikeliness=-10+EnhanceChance
		
		If CloseEncounters>17 
			SpawnInterval=180
		Else
			SpawnInterval=90
		End If
	ElseIf Score-WriteMask>2100000*ScoreOffset
	
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=-1+EnhanceChance; SpawnPause=0
		
		If CloseEncounters>25 And EnemyCount>35 ExtraLikeliness=1+EnhanceChance
		
		If CloseEncounters>40 And EnemyCount>44 ExtraLikeliness=2+EnhanceChance
		
		If CloseEncounters>60 And EnemyCount>54
			SpawnPause=4100+Rounds
			BreakTime:+4100
			CloseEncounters:-38
			LastDifficultyChange:+1050
			'SoundLoop.FadeOut(LOOP_TENSION)
		End If
		
		If Score-WriteMask<3520000*ScoreOffset
			If EnemyCount>56 And SpawnPause=0 SpawnPause=3400+Rounds;SpawnQueueFull=True '1600
			SpawnInterval=90
		ElseIf Score-WriteMask>3520000*ScoreOffset
			If EnemyCount>64 And SpawnPause=0 SpawnPause=2650+Rounds;SpawnQueueFull=True '1600
			SpawnInterval=0
		ElseIf Score-WriteMask>5600000*ScoreOffset
			If EnemyCount>66 And SpawnPause=0 SpawnPause=2650+Rounds;SpawnQueueFull=True '1600
			SpawnInterval=0
		End If
		If CloseEncounters>68 And EnemyCount>54 ExtraLikeliness=6+EnhanceChance
		
		If CloseEncounters<-8 And EnemyCount<55 ExtraLikeliness=-12+EnhanceChance

	End If
	
	'Wtf was this anyway?
	'If Score-WriteMask>3300000 BreakTime=Rand(6500,12000)
	If SeedDifficultyJudge>78 Then SpawnInterval:-35
	
	If SpawnPause=0 And SpawnQueueFull=True Then
		SpawnQueueFull=False
		SpawnPause=1000+Rounds
		BreakTime:+1000
	End If
	
	If ScoreMultiplier<1
		If Score-WriteMask>22897*ScoreOffset And Score-WriteMask<153897*ScoreOffset And Player.HasShot-Player.MaskShot<1 And Powerup.ShotsAvailable=0
			ExtraLikeliness=15+EnhanceChance
			ForceExtra=True
			SpawnInterval=160
		ElseIf Score-WriteMask>736214*ScoreOffset And Score-WriteMask<983897*ScoreOffset And Player.HasShot-Player.MaskShot<2 And Powerup.ShotsAvailable=0
			ForceExtra=True
			ExtraLikeliness=10+EnhanceChance
		End If
	Else
		If Score-WriteMask>22897 And Score-WriteMask<153897 And Player.HasShot-Player.MaskShot<1 And Powerup.ShotsAvailable=0
			ExtraLikeliness=16+EnhanceChance
			ForceExtra=True
			SpawnInterval=140
		ElseIf Score-WriteMask>736214 And Score-WriteMask<983897 And Player.HasShot-Player.MaskShot<2 And Powerup.ShotsAvailable=0
			ForceExtra=True
			ExtraLikeliness=11+EnhanceChance
		End If
	End If
	
	If Multiplier<>OldMultiplier
		Local Say:String="MULTIPLIER "+Multiplier+"X!"
		ScoreRegister.Fire(ScreenWidth/2,ScreenHeight/2-10,0,Say,2)
		OldMultiplier=Multiplier
		PlaySoundBetter Sound_Game_Multiplier,ScreenWidth/2,ScreenHeight/2,False,True
	End If
	
	If Not FrenzyMode And Frenzy>=16 And EnemyCount=>28
		ScoreRegister.Fire(ScreenWidth/2,ScreenHeight/2-10,0,"DOUBLE SCORE FRENZY!",2)
		FrenzyMode=MilliSecs()+7750
		If Player.HasSlowMotion>0
			Player.HasSlowMotion:+7750
		Else
			Player.HasSlowMotion=MilliSecs()+7750
		End If
		Player.ShotInterval:-75
		FrenzyGraph=Frenzy+1
		If Frenzy<=17
			Frenzy=0
		Else
			Frenzy:-17
		End If
		Trk_Frnz:+1
		PlaySoundBetter Sound_Game_Frenzy, FieldWidth/2,FieldHeight/2,False,True
		'EasterEgg=1
	End If
	
	If Not FrenzyMode
		If Frenzy<=16
			FrenzyGraph=Frenzy
		Else
			FrenzyGraph=16
		End If
	End If
	
	If FrenzyMode And FrenzyGraph>Frenzy FrenzyGraph:-.05*Delta
	
	If FrenzyMode And MilliSecs()-FrenzyMode=>0
		FrenzyMode=0
		Player.ShotInterval:+75
		FrenzyGraph=Frenzy+1
	End If
	
	If Multiplier<18 And EnemiesKilled>MultiplierAmount[Multiplier]
		Multiplier:+1	
	End If
	
	If WipeOutOnce<>0 And MilliSecs()-WipeOutOnce>0 WipeOutOnce=False
	
	If EnemyCount<=0 And WipeOutOnce=0 And Player.Alive And GameState=PLAYING Then
		Score:+EvenScore(1500*Multiplier*ScoreMultiplier)
		ScoreRegister.Fire(Player.x,Player.y-34,EvenScore(1500*Multiplier*ScoreMultiplier) ,"WIPE-OUT BONUS!",4)
		Frenzy:+2
		WipeOutOnce=MilliSecs()+15500
	End If
	
	If BreakTime>=22000 And SpawnPause<>0
		'Print "Broke Pause"
		LastDifficultyChange:-19050
		SpawnPause=SpawnPause/2
		BreakTime=0
		CloseEncounters=-1
	End If
	
	If EnemyCount<=0 And MilliSecs()-WipeOutOnce>-5000
		ForceSpawn=True
	End If	
	
	'If NearMissCount<>0 Then CloseEncounters:+1; Print CloseEncounters/GameTicks
	'If KeyHit(KEY_M) Print "Relative: "+(MilliSecs()-LastDifficultyChange)
	
	If SpawnPause=0 Or MilliSecs()-LastDifficultyChange>39500*SeedDifficultyChange
		'If Rounds Mod (2700+Difficulty*6500) = 0
			If Difficulty<4
				If MilliSecs()-LastDifficultyChange>11010*SeedDifficultyChange*Difficulty
					Difficulty:+1
					'Difficulty=Rounds/4100*(Difficulty*2)
					'Print "Difficulty: "+Difficulty
					'Print "PlaySeconds: "+((MilliSecs()-PlaySecs)/1000)
					LastDifficultyChange=MilliSecs()
					BreakTime=0
				End If
			ElseIf Difficulty<6
				If MilliSecs()-LastDifficultyChange>4850*SeedDifficultyChange*Difficulty
					Difficulty:+1
					'Difficulty=Rounds/4100*(Difficulty*2)
					'Print "Difficulty: "+Difficulty
					'Print "PlaySeconds: "+((MilliSecs()-PlaySecs)/1000)
					LastDifficultyChange=MilliSecs()
					BreakTime=0
				End If
			ElseIf Difficulty<14
				If MilliSecs()-LastDifficultyChange>3100*SeedDifficultyChange*Difficulty
					Difficulty:+1
					'Difficulty=Rounds/4100*(Difficulty*2)
					'Print "Difficulty: "+Difficulty
					'Print "PlaySeconds: "+((MilliSecs()-PlaySecs)/1000)
					LastDifficultyChange=MilliSecs()
					BreakTime=0
				End If
			Else
				If MilliSecs()-LastDifficultyChange>2760*SeedDifficultyChange*Difficulty
					Difficulty:+1
					'Difficulty=Rounds/4100*(Difficulty*2)
					'Print "Difficulty: "+Difficulty
					'Print "PlaySeconds: "+((MilliSecs()-PlaySecs)/1000)
					LastDifficultyChange=MilliSecs()
					BreakTime=0
				End If
			End If
		'End If
		'Difficulty=Rounds/4100
	End If
	
	If Difficulty>17 Then
		Difficulty=17
		If Score-WriteMask>3158765*ScoreOffset And SpeedGain<.325 SpeedGain:+0.0325
		LastDifficultyChange=MilliSecs()
		'Print "go up"+speedgain
	End If
	
	If SpawnPause>Rounds And EnemyCount>0
		Return
	ElseIf SpawnPause>Rounds And EnemyCount<=0
		SpawnPause:-5
		Return
	End If
	
	If Not Player.Alive And Difficulty>3 Difficulty=3
	
	
	If Score-WriteMask>4200000*ScoreOffset
		If Rounds/(380) Mod 2=0
			If Rounds Mod 33 = 0 
				SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty-1),3,450+SpawnInterval)
			End If
		End If
		If Rounds Mod (999) = 0 
			SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty-1),6,500+SpawnInterval)
		EndIf
		If Rounds Mod (777) = 0
			SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty-1),8,750+SpawnInterval) '2
		EndIf
	Else
		If Rounds/(380) Mod 2=0
			If Rounds Mod 33 = 0 
				SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty-1),1,500+SpawnInterval)
			End If
		End If
		If Rounds Mod (999) = 0 
			SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty),4,500+SpawnInterval)
		EndIf
		If Rounds Mod (777) = 0
			SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty-1),6,900+SpawnInterval) '2
		EndIf
	End If
	'whole bunch
	If Rounds Mod (2850) = 0
		'whole bunch
		SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty),8,1200+SpawnInterval) '3
	EndIf
	If Rounds Mod (4900) = 0
		'whole bunch
		SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty),10,1500+SpawnInterval) '4
	EndIf
	If ((Rounds/(4000)) Mod 2 = 1) And (Rounds Mod 3333 = 0)
		SpawnQueue.Add(Rand(1,Difficulty-1),Rand(1,Difficulty),12,1800+SpawnInterval) '6
	EndIf
	If ((Rounds/(8000)) Mod 2 = 1) And (Rounds Mod 6666 = 0)
		SpawnQueue.Add(Rand(1,Difficulty-1),Rand(1,Difficulty-1),14,1800+SpawnInterval) '6
	EndIf
	If Player.Alive And Difficulty<3 And EnemyCount<25 And FirstMassSpawn=True
		For Local i=1 To 25
			SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty),2,500)
		Next
		FirstMassSpawn=False
	End If
	If Player.Alive And ForceSpawn And EnemyCount<=0
		SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty),8,700+SpawnInterval)
	End If
	
End Function

Rem
'-----------------------------------------------------------------------------
'Function DoAI() handles the artifical intelligence of the "Spawn Director"
'-----------------------------------------------------------------------------
Function DoAI()
	
	If Debug If KeyHit(KEY_Z) Then SpawnQueue.Add(SCATTER,SMARTIE,1,100) 'SpawnQueue.Add(SCATTER,ERRATIC,200,1500)'SpawnQueue.Add(SCATTER,SSNAKE,5,1000)
	
	'If Debug If KeyHit(KEY_Z) Then Corruption.Spawn(Player.X,Player.Y)
	
	'Return
	If GameState=FIRSTSTART Return
	
	If SeedJumble(Seed)="LIAP@ELLI" And GameState=PLAYING And DoOnce=False
		SpawnQueue.Empty()
		SpawnQueue.Add(SCATTER,AASTEROID,8,100)
		SpawnPause=GameTicks+8000
		DoOnce=True
	End If
	'Reactive Loop Sample Prototype
	If CloseEncounters>45 And EnemyCount>50 And SpawnPause=False And Difficulty>3 And Player.HasShield=False
	
		'If TensionSounds SoundLoop.Play(Sound_Game_Tension,0,SoundVol,LOOP_TENSION)
		
	ElseIf CloseEncounters>55 And EnemyCount>65 And SpawnPause=False And Difficulty>4 And Player.HasShield>0
	
		'If TensionSounds SoundLoop.Play(Sound_Game_Tension,0,SoundVol,LOOP_TENSION)
	
	ElseIf CloseEncounters<=15 
	
		SoundLoop.FadeOut(LOOP_TENSION)
	
	End If
	
	If SpawnBlock Return
	
	Local Rounds=GameTicks
	
	If Score-WriteMask<55000
		
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=3; SpawnPause=0
		
		If CloseEncounters>8 And EnemyCount>25 ExtraLikeliness=5	
		
		If CloseEncounters>17 And EnemyCount>30 ExtraLikeliness=10
		
		If CloseEncounters>28 And EnemyCount>33
			SpawnPause=3150+Rounds '4500
			CloseEncounters:-15
			SoundLoop.FadeOut(LOOP_TENSION)
			If Difficulty>6 Difficulty:-1
		End If
		
		If CloseEncounters>32 And EnemyCount>35 ExtraLikeliness=15
		
		If CloseEncounters<-10 And EnemyCount<35 ExtraLikeliness=-4
		
		If EnemyCount>35 And SpawnPause=0 SpawnPause=2250+Rounds '2750
		
		If CloseEncounters> 10 
			SpawnInterval=225
		Else
			SpawnInterval=185
		End If
		
	ElseIf Score-WriteMask>55000 And Score-WriteMask<275000
	
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=2; SpawnPause=0
		
		If CloseEncounters>8 And EnemyCount>30 ExtraLikeliness=3	
		
		If CloseEncounters>16 And EnemyCount>40 ExtraLikeliness=6
		
		If CloseEncounters>32 And EnemyCount>45
			SpawnPause=3450+Rounds '4250
			CloseEncounters:-15
			SoundLoop.FadeOut(LOOP_TENSION)
			If Difficulty>8 Difficulty:-1
		End If
		
		If CloseEncounters>35 And EnemyCount>40 ExtraLikeliness=13
		
		If CloseEncounters<-10 And EnemyCount<35 ExtraLikeliness=-5
		
		If EnemyCount>39 And SpawnPause=0 SpawnPause=2150+Rounds '2050
		
		If CloseEncounters> 12 
			SpawnInterval=195
		Else
			SpawnInterval=175
		End If
		
	ElseIf Score-WriteMask>275000 And Score-WriteMask<645000
	
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=0; SpawnPause=0
		
		If CloseEncounters>15 And EnemyCount>30 ExtraLikeliness=3	
		
		If CloseEncounters>25 And EnemyCount>40 ExtraLikeliness=4
		
		If CloseEncounters>30 And EnemyCount>60
			SpawnPause=3225+Rounds '3400
			CloseEncounters:-18
			SoundLoop.FadeOut(LOOP_TENSION)
		End If
		
		If CloseEncounters>40 And EnemyCount>40 ExtraLikeliness=12
		
		If CloseEncounters<-10 And EnemyCount<35 ExtraLikeliness=-8
		
		If EnemyCount>42 And SpawnPause=0 SpawnPause=2205+Rounds '1600
		
		If CloseEncounters> 15 
			SpawnInterval=175
		Else
			SpawnInterval=165
		End If
	
	ElseIf Score-WriteMask>645000 And Score-WriteMask<950000
	
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=-1; SpawnPause=0
		
		If CloseEncounters>18 And EnemyCount>30 ExtraLikeliness=2	
		
		If CloseEncounters>29 And EnemyCount>40 ExtraLikeliness=3
		
		If CloseEncounters>35 And EnemyCount>40
			SpawnPause=3175+Rounds
			CloseEncounters:-19
			SoundLoop.FadeOut(LOOP_TENSION)
		End If
		
		If EnemyCount>45 And SpawnPause=0 SpawnPause=2150+Rounds '1600
		
		If CloseEncounters>45 And EnemyCount>70 ExtraLikeliness=10
		
		If CloseEncounters<-8 And EnemyCount<45 ExtraLikeliness=-9
		
		If CloseEncounters>20 
			SpawnInterval=165
		Else
			SpawnInterval=145
		End If
	
	ElseIf Score-WriteMask>950000 And Score-WriteMask<1650000
	
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=-1; SpawnPause=0
		
		If CloseEncounters>18 And EnemyCount>30 ExtraLikeliness=1	
		
		If CloseEncounters>29 And EnemyCount>40 ExtraLikeliness=3
		
		If CloseEncounters>35 And EnemyCount>65
			SpawnPause=2975+Rounds
			CloseEncounters:-20
			SoundLoop.FadeOut(LOOP_TENSION)
		End If
		
		If EnemyCount>47 And SpawnPause=0 SpawnPause=2050+Rounds '1600
		
		If CloseEncounters>45 And EnemyCount>75 ExtraLikeliness=9
		
		If CloseEncounters<-8 And EnemyCount<55 ExtraLikeliness=-10
		
		If CloseEncounters>35 
			SpawnInterval=155
		Else
			SpawnInterval=135
		End If
	
	ElseIf Score-WriteMask>1650000 And Score-WriteMask<2650000
	
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=-1; SpawnPause=0
		
		If CloseEncounters>18 And EnemyCount>30 ExtraLikeliness=1	
		
		If CloseEncounters>29 And EnemyCount>40 ExtraLikeliness=2
		
		If CloseEncounters>35 And EnemyCount>65
			SpawnPause=2875+Rounds
			CloseEncounters:-22
			SoundLoop.FadeOut(LOOP_TENSION)
		End If
		
		If EnemyCount>51 And SpawnPause=0 SpawnPause=2050+Rounds '1600
		
		If CloseEncounters>45 And EnemyCount>75 ExtraLikeliness=8
		
		If CloseEncounters<-8 And EnemyCount<70 ExtraLikeliness=-11
		
		If CloseEncounters>45 
			SpawnInterval=145
		Else
			SpawnInterval=115
		End If
	Else
	
		If Spawnpause<>0 And Rounds>SpawnPause CloseEncounters=0; ExtraLikeliness=-2; SpawnPause=0
		
		If CloseEncounters>25 And EnemyCount>35 ExtraLikeliness=1	
		
		If CloseEncounters>30 And EnemyCount>45 ExtraLikeliness=2
		
		If CloseEncounters>42 And EnemyCount>75
			SpawnPause=2655+Rounds
			CloseEncounters:-24
			SoundLoop.FadeOut(LOOP_TENSION)
		End If
		
		
		If Score-WriteMask<3185000
			If EnemyCount>62 And SpawnPause=0 SpawnPause=1975+Rounds '1600
		Else
			If EnemyCount>68 And SpawnPause=0 SpawnPause=1825+Rounds '1600
		End If
		
		If CloseEncounters>45 And EnemyCount>80 ExtraLikeliness=7
		
		If CloseEncounters<-8 And EnemyCount<80 ExtraLikeliness=-12
		
		SpawnInterval=95
		
	End If
	
	If Score-WriteMask>19500 And Player.HasShot<1 And Powerup.ShotsAvailable<1
		ExtraLikeliness=16
		ForceExtra=True
		SpawnInterval=170
	End If
	
	If Multiplier<>OldMultiplier
		Local Say:String="MULTIPLIER "+Multiplier+"X!"
		ScoreRegister.Fire(ScreenWidth/2,ScreenHeight/2-10,0,Say,2)
		OldMultiplier=Multiplier
		PlaySoundBetter Sound_Game_Multiplier,ScreenWidth/2,ScreenHeight/2,False,True
	End If
	
	If Not FrenzyMode And Frenzy>=16
		ScoreRegister.Fire(ScreenWidth/2,ScreenHeight/2-10,0,"NEAR MISS FRENZY!",2)
		FrenzyMode=MilliSecs()+7750
		If Player.HasSlowMotion>0
			Player.HasSlowMotion:+7750
		Else
			Player.HasSlowMotion:+MilliSecs()+7750
		End If
		Player.ShotInterval:-75
		FrenzyGraph=Frenzy+1
		Frenzy=0
		PlaySoundBetter Sound_Game_Frenzy, FieldWidth/2,FieldHeight/2,False,True
		'EasterEgg=1
	End If
	
	If Not FrenzyMode
		FrenzyGraph=Frenzy
	End If
	
	If FrenzyMode And FrenzyGraph>Frenzy FrenzyGraph:-.05*Delta
	
	If FrenzyMode And MilliSecs()-FrenzyMode>0
		FrenzyMode=0
		Player.ShotInterval:+75
		FrenzyGraph=Frenzy
	End If
	
	If Multiplier<16 And EnemiesKilled>MultiplierAmount[Multiplier]
		Multiplier:+1	
	End If
	
	If SpawnPause>Rounds And EnemyCount>0
		Return
	ElseIf SpawnPause>Rounds And EnemyCount<=0
		SpawnPause:-15
		Return
	End If
	'If NearMissCount<>0 Then CloseEncounters:+1; Print CloseEncounters/GameTicks
	
	If Rounds Mod ((4600+SpawnInterval)+(Difficulty*220)) = 0
		If MilliSecs()-LastDifficultyChange>9650
			Difficulty:+1
			LastDifficultyChange=MilliSecs()
		End If
	End If
	'Difficulty=Rounds/4100
	If Difficulty>14 Then Difficulty=14
	
	If Not Player.Alive And Difficulty>3 Difficulty=3
	
	If Rounds/(380+SpawnInterval) Mod 2=0
		If Rounds Mod 33 = 0 
			SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty-1),1,500)
		End If
	End If
	
	If Rounds Mod (999+SpawnInterval) = 0 
		'Print "Event 2!"
		SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty),2,500)
	EndIf
	'whole bunch
	If Rounds Mod (777+SpawnInterval) = 0
		SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty-1),6,900) '2
	EndIf
	If Rounds Mod (2850+SpawnInterval) = 0
		'whole bunch
		SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty),8,1200) '3
	EndIf
	If Rounds Mod (4900+SpawnInterval) = 0
		'whole bunch
		SpawnQueue.Add(Rand(0,Difficulty-1),Rand(0,Difficulty),10,1500) '4
	EndIf
	If ((Rounds/(5000+SpawnInterval)) Mod 2 = 1) And (Rounds Mod 3333 = 0)
		SpawnQueue.Add(Rand(1,Difficulty-1),Rand(1,Difficulty),12,1800) '6
	EndIf
	
	Rem
	'SpawnQueue(SPAWNTYPE, ENEMY KIND, AMOUNT, INTERVAL)
	'Difficulty:+EnemiesKilled/((MilliSecs()-PlaySecs)/10)

	
	If EnemiesKilled=0 And Difficulty=0
	
		SpawnQueue.Add(Rnd(0,1),BOUNCER,25,1600)
		Difficulty:+1
	
	End If
	
	If EnemyCount<20 And Difficulty<2
	
		SpawnQueue.Add(Rnd(1,3),BOUNCER,45,1600)
		Difficulty:+1
	
	End If
	
	If MilliSecs()-PlaySecs>16000 And EnemyCount<38 And Difficulty<4
	
		SpawnQueue.Add(Rnd(2,5),FOLLOWER,35,1900)
		Difficulty:+1
	
	End If
	
	If EnemyCount<45 And Difficulty>2 And Difficulty<5
	
		SpawnQueue.Add(Rnd(3,5),Rand(FOLLOWER,PANICER),35,2200)
		Difficulty:+1
	
	End If
	
	If Difficulty>3 And EnemyCount<35 And MilliSecs()-PlaySecs>20000
	
		SpawnQueue.Add(SURROUND,BOUNCER,55,4000)
	
	End If
	
	If Rnd(1,1000)=42 Then SpawnQueue.Add(Rnd(0,3),Rand(BOUNCER,EVADER),25,1600)
	
End Function
End Rem

'-----------------------------------------------------------------------------
'Function DoGame() is the main game function
'-----------------------------------------------------------------------------
Function DoGame()
	
		
	'Update the game of life only every 12 Gameticks to conserve CPU
	If BackgroundStyle>0 And BackgroundStyle<5 And MilliSecs()-LifeTick>=55+(1000/FPSCurrent) Then
		GameOfLife.Update()
		LifeTick=MilliSecs()
	End If
	'Print 25+FixedRateLogic.MS/4
	If BackgroundStyle=7 Or BackgroundStyle=8 Then
		'If VerticalSync<>0
			If MilliSecs()-BackGroundTick>=30+(1000/FPSCurrent)

			'If MilliSecs()-BackGroundTick>=((30/Delta))
				'Print Int((30/Delta*10))
				Water.Update()
				BackgroundTick=MilliSecs()
			End If
		'Else
		'	If MilliSecs()-BackGroundTick>=30+(1000/FPSCurrent)
			
			'	Water.Update()
			'	BackgroundTick=MilliSecs()

		'	End If
		'End If
	End If
	If BackgroundStyle=5 Background.UpdateAll()
	If BackgroundStyle=9 Or BackgroundStyle=10 BoxedIn.UpdateAll()
	If BackgroundStyle=11 GridHit.UpdateAll()
	If BackgroundStyle=12 Or BackgroundStyle=13 UpRising.UpdateAll()
	If BackgroundStyle=14 Or BackgroundStyle=15 Squared.UpdateAll()
	
	MotionBlur.UpdateAll()
	
	ParticleManager.UpdateAll()
	
	Glow.UpdateAll()
	Shot.UpdateAll()
	ShotGhost.UpdateAll()
	Thrust.UpdateAll()
	
	BombHUD.UpdateAll()
	'Get key inputs and update the ship
	Player.Update()
	Invader.UpdateAll()
	
	PlayerBomb.UpdateAll()
	Flash.UpdateAll()
	
	Explosion.UpdateAll()
	ShockWave.UpdateAll()
	
	'Glow.UpdateAll()
	
	PowerUp.UpdateAll()
	SpawnEffect.UpdateAll()
	Spinner.UpdateAll()
	Chaser.UpdateAll()
	MineLayer.UpdateAll()
	Mine.UpdateAll()
	Asteroid.UpdateAll()
	Boid.UpdateAll()
	Thief.UpdateAll()
	CorruptedInvader.UpdateAll()
	Lightning.UpdateAll()
	
	Corruption.UpdateAll()
	'CorruptionEffect.UpdateAll()
	CorruptionNode.UpdateAll()
	ScoreRegister.UpdateAll()
	'Reacher.UpdateAll()
	'ViewPortX=MouseX()
	'ViewPortY=MouseY()
	
	'DataProbe
	DataProbe.UpdateAll()
	
	Snake.UpdateAll()
	SpawnQueue.UpdateAll()
	
	'DataNode.UpdateAll()
	

	ScreenShake.Update()
	'SoundLoop.UpdateAll()

	
End Function

'-----------------------------------------------------------------------------
'Function DrawGame() draws out everything that happens ingame
'-----------------------------------------------------------------------------
Function DrawGame()
	
	ScreenShake.Draw()
	
	Select FullScreenGlow
	
	Case 1
		SetAlpha 1
		SetBlend ALPHABLEND
		
		'--------------Render to texture first!--------
		tRender.TextureRender_Begin(BloomFilter)
		'CLS Disabled as a Test
		'trender.Cls 
		'Make sure the correct color is set
		SetAlpha 1
		If BackgroundStyle>0 And BackgroundStyle<5 GameOfLife.Draw()
		'Draw the Players Ship
		SetBlend ALPHABLEND
		'SetColor (255,0,255)
		If BackgroundStyle=5 Background.DrawAll()
		If BackgroundStyle=6 TStarfield.DrawAll(Player.X,Player.Y,3)
		If BackgroundStyle=7 Water.Draw()
		If BackgroundStyle=8 Water.Draw(True)
		If BackgroundStyle=9 BoxedIn.DrawAll(False)
		If BackgroundStyle=10 BoxedIn.DrawAll(True)
		If BackgroundStyle=11 GridHit.DrawAll()
		If BackgroundStyle=12 UpRising.DrawAll(False)
		If BackgroundStyle=13 UpRising.DrawAll(True)
		If BackgroundStyle=14 Squared.DrawAll(False,False)
		If BackgroundStyle=15 Squared.DrawAll(False,True)
		Corruption.DrawAll()
		MotionBlur.DrawAll()
		'CorruptionEffect.DrawAll()
		CorruptionNode.DrawAllGlow()
		'DataNode.DrawAllGlow()
		'Reacher.DrawAll(True)
		
		
		Shot.DrawAllGlow()
		SpawnEffect.DrawAll()
		PowerUp.DrawAllGlow()
		Invader.DrawAllGlow()
		Spinner.DrawAllGlow()
		Snake.DrawAllGlow()
		Chaser.DrawAllGlow()
		Mine.DrawAllGlow(False)
		MineLayer.DrawAllGlow()
		Asteroid.DrawAllGlow()
		Boid.DrawAllGlow()
		Thief.DrawAllGlow()
		'Dataprobe
		DataProbe.DrawAllGlow()
		CorruptedInvader.DrawAllGlow()
		
		Thrust.DrawAll()
		Player.DrawGlow()
		'PowerUp.DrawAll()
		'SetColor (0,255,0)
		ShotGhost.DrawAll()
		
		ParticleManager.DrawAllGlow()
		
		'
		Glow.DrawAll()
		Explosion.DrawAllGlow()
		ShockWave.DrawAll()
		'SetColor (205,205,205)
		Flash.DrawAllGlow()
		Lightning.DrawAllGlow()
		'SetColor (255,255,255)
		ScoreRegister.DrawAllGlow()
		'ScoreRegister.DrawAll()

		If FPSCurrent<200 Or EasterEgg=True
			'Cool Scanline effect
			SetLineWidth 1
			SetBlend ALPHABLEND
			SetRotation 0
			SetScale 2,2
			SetColor 0,0,0
			If EasterEgg<>1
				SetAlpha ScanlineFader/2
			ElseIf EasterEgg=1
				SetAlpha .8
			End If

			If GlowQuality>256 Then SetLineWidth 2
			If GlowQuality>512 Then SetLineWidth 2.5
			
			If GlLines
				glDisable GL_TEXTURE_2D; glBegin GL_LINES
				If GlowQuality>256 glLineWidth 2
				If GlowQuality>512 glLineWidth 2.5
				
				For Local i=1 To ScreenHeight Step 9
					glVertex2f 0,i
					glVertex2f ScreenWidth,i
				Next
				
				glEnd; glEnable GL_TEXTURE_2D
			Else
				For Local i=1 To ScreenHeight Step 9
					DrawLine(0,i,ScreenWidth,i,True)
				Next
			End If
			
		End If
		If FrenzyMode
			SetAlpha ScanlineFader+.25
			SetScale 3,3
			SetColor 255,128,0
			DrawImage FrenzyMeter,FieldWidth-240,33
			DrawSubImageRect FrenzyBar,FieldWidth-240,33,1+FrenzyGraph*4,7,0,0,1+FrenzyGraph*4,7
			SetColor 255,255,255
			SetScale 1,1
			SetAlpha 1
		End If
		tRender.TextureRender_End() 
		

		
		SetColor 255,255,255
		'-------- now render the backbuffer ---------
		
		tRender.BackBufferRender_Begin() 
		tRender.Cls(ClsColor)
		'Make sure the correct color is set
		'Draw the Players Ship
		'SetColor (255,0,255)
		Corruption.DrawAll()
		'CorruptionEffect.DrawAll()
		CorruptionNode.DrawAll()
		'DataNode.DrawAll()
		'Reacher.DrawAll()
		Shot.DrawAll()
		
		SpawnEffect.DrawAll()
		Invader.DrawAll()
		Spinner.DrawAll()
		Snake.DrawAll()
		Chaser.DrawAll()
		Mine.DrawAll()
		MineLayer.DrawAll()
		Asteroid.DrawAll()
		Boid.DrawAll()
		Thief.DrawAll()
		CorruptedInvader.DrawAll()
		'PlayerGhost.DrawAll()
		
		'DataProbe
		DataProbe.DrawAll()
		
		PowerUp.DrawAll()
		'SetColor (0,255,0)
		ShotGhost.DrawAll()
		
		Thrust.DrawAll()
		Glow.DrawAll()
		Explosion.DrawAll()
		ShockWave.DrawAll()
		Lightning.DrawAll()
		'Flash.DrawAll()
		ScoreRegister.DrawAll()
		Player.Draw() 
		ParticleManager.DrawAll()
		PlayerBomb.DrawAll()
		SetBlend LIGHTBLEND
		If FPSCurrent<200
			SetAlpha .55+ScanlineFader
		Else
			SetAlpha .55+ScanlineFader
		End If

		DrawImageRect BloomFilter,0,0,ScreenWidth,ScreenHeight
		
		tRender.BackBufferRender_End()
		
		SetAlpha 1
		SetBlend ALPHABLEND

	Default
		'Reduce alpha so backgrounds don't stand out as much when drawn in Non-Buffered Mode
		SetAlpha .55
		If BackgroundStyle>0 And BackgroundStyle<5 GameOfLife.Draw()
		'Make sure the correct color is set
		'SetColor (255,0,255)
		If BackgroundStyle=5 Background.DrawAll(True)
		If BackgroundStyle=6 TStarfield.DrawAll(Player.X,Player.Y,3,True)
		If BackgroundStyle=7 Water.Draw()
		If BackgroundStyle=8 Water.Draw(True)
		If BackgroundStyle=9 BoxedIn.DrawAll(False,True)
		If BackgroundStyle=10 BoxedIn.DrawAll(True,True)
		If BackgroundStyle=11 GridHit.DrawAll(True)
		If BackgroundStyle=12 UpRising.DrawAll(False,True)
		If BackgroundStyle=13 UpRising.DrawAll(True,True)
		If BackgroundStyle=14 Squared.DrawAll(True,False)
		If BackgroundStyle=15 Squared.DrawAll(True,True)
		SetAlpha 1
		Corruption.DrawAll()
		MotionBlur.DrawAll()
		'CorruptionEffect.DrawAll()
		'Reacher.DrawAll(True)
		'Reacher.DrawAll(False)
		CorruptionNode.DrawAll()
		'DataNode.DrawAll()
		Shot.DrawAll()
		SpawnEffect.DrawAll()
		Invader.DrawAll()
		Spinner.DrawAll()
		Snake.DrawAll()
		Chaser.DrawAll()
		Mine.DrawAll()
		Mine.DrawAllGlow(True)
		MineLayer.DrawAll()
		Asteroid.DrawAll()
		Boid.DrawAll()
		Thief.DrawAll()
		CorruptedInvader.DrawAll()
		
		'DatProbe
		DataProbe.DrawAll()
		
		Thrust.DrawAll()
		Player.Draw()
		PowerUp.DrawAll()
		'SetColor (0,255,0)
		ShotGhost.DrawAll()
		ParticleManager.DrawAll()
	
		'
		Glow.DrawAll()
		Explosion.DrawAll(True)
		ShockWave.DrawAll()
		'SetColor (205,205,205)
		Flash.DrawAll()
		Lightning.DrawAll()
		'SetColor (255,255,255)
		
		ScoreRegister.DrawAll()
		PlayerBomb.DrawAll()
		
	End Select
	
End Function

'-----------------------------------------------------------------------------
'Function ProcessMainMenu() Calculates the Animation for the Main Menu
'-----------------------------------------------------------------------------
Global LastCalc:Int
Function ProcessMainMenu()
	If MilliSecs()-LastCalc>75
		CalcLogo()
		LastCalc=MilliSecs()
	End If
	MainMenu.Update(0,10)
	
End Function
Global MoveUp:Float
'-----------------------------------------------------------------------------
'Function DrawMainMenu() Draws the Main Menu
'-----------------------------------------------------------------------------
Function DrawMainMenu()
	

	DarkenScreen(.35)
	SetRotation 0
	SetAlpha 1
	SetScale 1,1
	
	If GAMESTATE<>CREDITS
		If Not MainMenu.GraphicsError DoLogo (ScreenWidth/2+7,144)
		'DrawImage GameLogo,screenwidth/2,150
		SetScale (0.5,0.5)
		'BoldFont.Draw(SeedJumble("+F,534305344#PDQXHO#YDQ#G\FN"),ScreenWidth-254,ScreenHeight-30)
		'BoldFont.Draw(SeedJumble("+F,PDQXHO#YDQ#G\FN#5343"),ScreenWidth-220,ScreenHeight-30)
		BoldFont.Draw(SeedJumble("+f,Pdqxho#ydq#G|fn#5343#0#5346"),ScreenWidth-279,ScreenHeight-30)
		MainMenu.Update(0,10,True)
		MainMenu.Draw(0,10)
		'MainMenu.Draw()
	End If
	If MenuFade.Test()
		MenuFade.Redraw()
	Else
		MenuFade.AlphaValue=0.0
	End If
	'FlushKeys()
	'FlushMouse()
	
End Function

'-----------------------------------------------------------------------------
'Function LoadIniFile() loads the ini file and sets the according globals
'-----------------------------------------------------------------------------
Function LoadIniFile()
	Local Ini_File:TStream
	Local Temporary_String:String
	Local Temporary_Value:String
	Local j:Int 
	
	
	?MacOS
	Local DirExists:Byte
	Local DirCreated:Byte
	
	Try
		ChangeDir "./"
		DirExists=ChangeDir(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption")

		If Not DirExists
			DirCreated=CreateDir(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption")
		End If
		
		If DirCreated=False And DirExists=False Then Throw "NoDir"
		
	Catch NoDir$
		
		RuntimeError("Couldn't create directory:~n"+GetUserHomeDir()+"/Library/Application Support/Invaders Corruption")
		End
	
	End Try
	
	Ini_File=OpenFile(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/settings.ini",True,False)
	
	If Not Ini_File Then
		CopyFile  (GetBundleResource("settings.ini"),GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/settings.ini")
		Ini_File=OpenFile(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/settings.ini",True,False)
	End If
			
	?
	'See if we can get our hands on an inifile 
	?Win32
	Try
				
		'Windows
		Ini_File=OpenFile("settings.ini",True,False)
		
		If Not  Ini_File Then Throw "bleh"
		
	Catch bleh$
	
		Notify ("Settings.ini - File could not be found, restoring default settings.")
		
		Ini_File=OpenFile(GetBundleResource("settings.ini"),True,False)
		
		CopyFile  (GetBundleResource("settings.ini"),"settings.ini")
		'No Inifile? - Insert Defaulting routine here
		'End
		
	End Try 
	?
	
	While Not Eof(Ini_File)
		'do ini file readout
	
		Temporary_String=ReadLine(Ini_File)
		
		'is this a hard return - skip it
		If Temporary_String="" Then Continue
		'is this a comment or a header - skip it then
		If Left$(Temporary_String,1)="[" Or Left$(Temporary_String,1)=";" Then Continue
		
		
		'search for a trailing ; marking a comment and remove it
		j=Temporary_String.find(";")
		'did we find a comment - get rid of it
		If j<>-1
			Temporary_String=Temporary_String[..j]
		End If
		
		
		'search for the '=' sign as it devides declarer and value
		j=Temporary_String.find("=")
		
		'did we find an '='? otherwise j=-1
		If j<>-1
			Temporary_Value=Temporary_String[j+1..]				'get the value
			Temporary_String=Upper(Temporary_String[..j])		'get the declarer and UPcase it
		EndIf
		
		
		'now lets read out & set all those values
		Select Temporary_String
		
			Case "FULL_SCREEN"
				If Int(Temporary_Value)>=0 And Int(Temporary_Value)<=1 Then
					FullScreen=Int(Temporary_Value)
				Else
					FullScreen=0
				End If
				
			Case "BITS_PER_PIXEL"
				If Int(Temporary_Value)=32 Or Int(Temporary_Value)=16 Or Int(Temporary_Value)=24 Then
					BitDepth=Int(Temporary_Value)
				Else
					BitDepth=32
				End If
				
			Case "REFRESHRATE"
				If Int(Temporary_Value)=>50 And Int(Temporary_Value)<=300 Then
					RefreshRate=Int(Temporary_Value)
				Else
					RefreshRate=60
				End If
				
			Case "V_SYNC"
				If Int(Temporary_Value)>=0 And Int(Temporary_Value)<=1 Then
					If Int(Temporary_Value)=0 Then
						VerticalSync=0
					Else
						VerticalSync=-1
					End If
				Else
					VerticalSync=0
				End If
				
			Case "GRAPHICS_DRIVER"
				If Upper(Temporary_Value)="DIRECTX" Then
					GraphicsDriver=1
				Else
					GraphicsDriver=2
				End If
			
			Case "WIDESCREEN"
				If Int(Temporary_Value)>=0 And Temporary_Value<>"" Then
					WideScreen=Int(Temporary_Value)
					If WideScreen
						If RecommendedWideHeight=0 And RecommendedWideWidth=0 Then WideScreen=0
					Else
						If RecommendedTallHeight=0 And RecommendedTallWidth=0 Then WideScreen=0
					End If
				Else
					If Float(DWidth)/Float(DHeight)=>1.38
						WideScreen=True
					Else
						WideScreen=False
					End If
					If WideScreen
						If RecommendedWideHeight=0 And RecommendedWideWidth=0 Then WideScreen=0
					Else
						If RecommendedTallHeight=0 And RecommendedTallWidth=0 Then WideScreen=0
					End If
				End If
				'Change Playfield Sizes According to Widescreen Setting
				If WideScreen=False
					FieldWidth = 1024
					FieldHeight = 768
					ScreenWidth  = 1024							'Actual Screen resolution
					ScreenHeight = 768
				Else
					FieldWidth = 1280
					FieldHeight = 768
					ScreenWidth = 1280
					ScreenHeight = 768
				End If
				
			Case "SCREEN_WIDTH"
				If Int(Temporary_Value)>=0 And Temporary_Value<>"" Then
					RealWidth=Int(Temporary_Value)
					If RealWidth>DWidth Then RealWidth=DWidth
				Else
					If WideScreen=False
						RealWidth=RecommendedTallWidth
					Else
						RealWidth=RecommendedWideWidth
					End If
					If RealWidth>DWidth Then RealWidth=DWidth
				End If
				
			Case "SCREEN_HEIGHT"
				If Int(Temporary_Value)>=0 And Temporary_Value<>"" Then
					RealHeight=Int(Temporary_Value)
					If RealHeight>DHeight Then RealHeight=DHeight
				Else
					If WideScreen=False
						RealHeight=RecommendedTallHeight
					Else
						RealHeight=RecommendedWideHeight
					End If
					If RealHeight>DHeight Then RealHeight=DHeight
				End If
				
			Case "PARTICLE_DENSITY"
				If Int(Temporary_Value)>=10 And Int(Temporary_Value)<=400 Then
					ParticleMultiplier=Float(Temporary_Value)
					ParticleMultiPlier:/100
					If ParticleMultiplier>1.3 And ParticleMultiplier<1.5 Then
						ParticleMultiplier=1.40000
					End If
					If ParticleMultiplier>0.3 And ParticleMultiplier<.37 Then
						ParticleMultiplier=0.35000
					End If
				Else
					ParticleMultiplier=1
				End If
				
			Case "INPUT_METHOD"
				If Int(Temporary_Value)=0 Or Int(Temporary_Value)<5 Then
					InputMethod=Int(Temporary_Value)
				Else
					InputMethod=1
				End If
				
			Case "MUSIC_VOLUME"
				If Int(Temporary_Value)>=0 And Int(Temporary_Value)<110 Then
					MusicVolInt=Int(Temporary_Value)
					Local Holder:Float=Int(Temporary_Value)
					MusicVol=Holder/100
				Else
					If Int(Temporary_Value)>100 Then MusicVol=1.00
				End If


			Case "SOUND_VOLUME"
				If Int(Temporary_Value)>=0 And Int(Temporary_Value)<110 Then
					SoundVolInt=Int(Temporary_Value)
					Local Holder:Float=Int(Temporary_Value)
					SoundVol=Holder/100
				Else
					If Int(Temporary_Value)>100 Then SoundVol=1.00
				End If
			
			Case "AUDIO_MODE"
				If Upper(Temporary_Value)="MONO" Then
					SoundMode=0
				ElseIf Upper(Temporary_Value)="STEREO" Then
					SoundMode=1
				Else 
					SoundMode=1
				End If
			
			Case "FORCE_RES"
				If Int(Temporary_Value)=0 Or Int(Temporary_Value)=1 Then
					ForceRes=Int(Temporary_Value)
				Else
					ForceRes=0
				End If
				
			Case "BACKBUFFER_ENABLE"
				If Int(Temporary_Value)=0 Or Int(Temporary_Value)=1 Then
					FullScreenGlow=Int(Temporary_Value)
				Else
					FullScreenGlow=0
				End If
				
			Case "AUTOFIRE"
				If Int(Temporary_Value)=0 Or Int(Temporary_Value)=1 Then
					AutoFire=Int(Temporary_Value)
				Else
					AutoFire=0
				End If
				
			Case "MOTION_BLUR"
				If Int(Temporary_Value)>=0 Or Int(Temporary_Value)<=2 Then
					MotionBlurEnable=Int(Temporary_Value)
					If MotionBlurEnable<=1 Then
						BlurDivider=2.4
					ElseIf MotionBlurEnable=2
						BlurDivider=3.6
					End If
				Else
					MotionBlurEnable=1
					If MotionBlurEnable<=1 Then
						BlurDivider=2.4
					ElseIf MotionBlurEnable=2
						BlurDivider=3.6
					End If
				End If
				
			Case "PURE_BLACKS"
				If Int(Temporary_Value)=0 Or Int(Temporary_Value)=1 Then
					PureBlacks=Int(Temporary_Value)
				Else
					PureBlacks=0
				End If
			
			Case "SCREEN_SHAKE"
				If Int(Temporary_Value)=0 Or Int(Temporary_Value)=1 Then
					ScreenShakeEnable=Int(Temporary_Value)
				Else
					ScreenShakeEnable=True
				End If
			
			Case "BACKGROUND_TYPE"
				If Int(Temporary_Value)=>0 Or Int(Temporary_Value)<=16 Then
					BackGroundstyle=Int(Temporary_Value)
					If BackGroundStyle=16 Then UseSeedStyle=True
				Else
					BackgroundStyle=1
					UseSeedStyle=False
				End If

			Case "CURSOR_TYPE"
				If Int(Temporary_Value)=>0 Or Int(Temporary_Value)<=5 Then
					CrossHairType=Int(Temporary_Value)
				Else
					CrossHairType=1
				End If
				
				'------------------KEYBOARD----------------------------
				
			Case "KB_MOVE_UP"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_UP,0]=Int(Temporary_Value)
				Else
					InputCache[MOVE_UP,0]=KEY_W
				End If
				
			Case "KB_MOVE_DOWN"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_DOWN,0]=Int(Temporary_Value)
				Else
					InputCache[MOVE_DOWN,0]=KEY_S
				End If
				
			Case "KB_MOVE_LEFT"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_LEFT,0]=Int(Temporary_Value)
				Else
					InputCache[MOVE_LEFT,0]=KEY_A
				End If

			Case "KB_MOVE_RIGHT"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_RIGHT,0]=Int(Temporary_Value)
				Else
					InputCache[MOVE_RIGHT,0]=KEY_D
				End If

			Case "KB_SHOOT_CANNON"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[FIRE_CANNON,0]=Int(Temporary_Value)
				Else
					InputCache[FIRE_CANNON,0]=KEY_RCONTROL
				End If
				
			Case "KB_SHOOT_BOMB"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[FIRE_BOMB,0]=Int(Temporary_Value)
				Else
					InputCache[FIRE_BOMB,0]=KEY_RALT
				End If

				'------------------KEYBOARD & MOUSE----------------------------
				
			Case "M_MOVE_UP"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_UP,1]=Int(Temporary_Value)
					InputCache[MOVE_UP,2]=Int(Temporary_Value)
				Else
					InputCache[MOVE_UP,1]=KEY_W
					InputCache[MOVE_UP,2]=KEY_W
				End If
				
			Case "M_MOVE_DOWN"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_DOWN,1]=Int(Temporary_Value)
					InputCache[MOVE_DOWN,2]=Int(Temporary_Value)
				Else
					InputCache[MOVE_DOWN,1]=KEY_S
					InputCache[MOVE_DOWN,2]=KEY_S
				End If
				
			Case "M_MOVE_LEFT"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_LEFT,1]=Int(Temporary_Value)
					InputCache[MOVE_LEFT,2]=Int(Temporary_Value)
				Else
					InputCache[MOVE_LEFT,1]=KEY_A
					InputCache[MOVE_LEFT,2]=KEY_A
				End If

			Case "M_MOVE_RIGHT"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_RIGHT,1]=Int(Temporary_Value)
					InputCache[MOVE_RIGHT,2]=Int(Temporary_Value)
				Else
					InputCache[MOVE_RIGHT,1]=KEY_D
					InputCache[MOVE_RIGHT,2]=KEY_D
				End If

			Case "M_SHOOT_CANNON"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[FIRE_CANNON,1]=Int(Temporary_Value)
					InputCache[FIRE_CANNON,2]=Int(Temporary_Value)
				Else
					InputCache[FIRE_CANNON,1]=1
					InputCache[FIRE_CANNON,2]=1
				End If
				
			Case "M_SHOOT_BOMB"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[FIRE_BOMB,1]=Int(Temporary_Value)
					InputCache[FIRE_BOMB,2]=Int(Temporary_Value)
				Else
					InputCache[FIRE_BOMB,1]=2
					InputCache[FIRE_BOMB,2]=2
				End If
				
			'------------------JOYPAD----------------------------
				
			Case "JOY_MOVE_UP"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_UP,3]=Int(Temporary_Value)
				Else
					InputCache[MOVE_UP,3]=0
				End If
				
			Case "JOY_MOVE_DOWN"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_DOWN,3]=Int(Temporary_Value)
				Else
					InputCache[MOVE_DOWN,3]=0
				End If
				
			Case "JOY_MOVE_LEFT"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_LEFT,3]=Int(Temporary_Value)
				Else
					InputCache[MOVE_LEFT,3]=0
				End If

			Case "JOY_MOVE_RIGHT"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_RIGHT,3]=Int(Temporary_Value)
				Else
					InputCache[MOVE_RIGHT,3]=0
				End If

			Case "JOY_SHOOT_CANNON"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[FIRE_CANNON,3]=Int(Temporary_Value)
				Else
					InputCache[FIRE_CANNON,3]=0
				End If
				
			Case "JOY_SHOOT_BOMB"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[FIRE_BOMB,3]=Int(Temporary_Value)
				Else
					InputCache[FIRE_BOMB,3]=0
				End If
			
			'------------------DUAL AXIS JOYPAD----------------------------
				
			Case "DUO_MOVE_UP"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_UP,4]=Int(Temporary_Value)
				Else
					InputCache[MOVE_UP,4]=0
				End If
				
			Case "DUO_MOVE_DOWN"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_DOWN,4]=Int(Temporary_Value)
				Else
					InputCache[MOVE_DOWN,4]=0
				End If
				
			Case "DUO_MOVE_LEFT"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_LEFT,4]=Int(Temporary_Value)
				Else
					InputCache[MOVE_LEFT,4]=0
				End If

			Case "DUO_MOVE_RIGHT"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[MOVE_RIGHT,4]=Int(Temporary_Value)
				Else
					InputCache[MOVE_RIGHT,4]=0
				End If

			Case "DUO_SHOOT_CANNON"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[FIRE_CANNON,4]=Int(Temporary_Value)
				Else
					InputCache[FIRE_CANNON,4]=0
				End If
				
			Case "DUO_SHOOT_BOMB"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[FIRE_BOMB,4]=Int(Temporary_Value)
				Else
					InputCache[FIRE_BOMB,4]=0
				End If
				'------------------DUAL AXIS AIM----------------------------
				
			Case "DUO_AIM_UP"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[AIM_UP,4]=Int(Temporary_Value)
				Else
					InputCache[AIM_UP,4]=0
				End If

			Case "DUO_AIM_DOWN"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[AIM_DOWN,4]=Int(Temporary_Value)
				Else
					InputCache[AIM_DOWN,4]=0
				End If
				
			Case "DUO_AIM_LEFT"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[AIM_LEFT,4]=Int(Temporary_Value)
				Else
					InputCache[AIM_LEFT,4]=0
				End If				

			Case "DUO_AIM_RIGHT"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=266 Then
					InputCache[AIM_RIGHT,4]=Int(Temporary_Value)
				Else
					InputCache[AIM_RIGHT,4]=0
				End If
			
			Case "JOY_DEADZONE_ADJUST"
				If Int(Temporary_Value)=>0 Or Int(Temporary_Value)<=10 Then
					JoyDeadZoneAdjust=Int(Temporary_Value)
				Else
					JoyDeadZoneAdjust=1
				End If		
			
			Case "MOUSE_SENSIVITY"
				If Int(Temporary_Value)=>1 Or Int(Temporary_Value)<=20 Then
					MouseSensivity=Int(Temporary_Value)
				Else
					MouseSensivity=10
				End If
					
			Case "RANDOM_SEED"
				If Temporary_Value<>""
					Seed=SanitizeInput(Temporary_Value,25)
				Else
					Seed=""
				End If
			
			Case "PLAYER_NAME"
				If Temporary_Value<>""
					PlayerName=SanitizeInput(Temporary_Value,21)
				Else
					PlayerName=""
				End If
				
			Case "UNIQUE_ID"
				If Temporary_Value<>""
					UniqueID=SanitizeInput(Temporary_Value,33,True)
				Else
					UniqueID=""
				End If
			
			Case "BACKBUFFER_RES"
				If Temporary_Value<>""
					Select Int(Temporary_Value)
						Case 32
							GlowQuality=32
						Case 64
							GlowQuality=64
						Case 128
							GlowQuality=128
						Case 256
							GlowQuality=256
						Case 512
							GlowQuality=512
						Case 768
							GlowQuality=768
						Case 1024
							GlowQuality=1024
						Default
							GlowQuality=256
					End Select
				Else
					GlowQuality=256
				End If
				'Make sure that the GLOW fits within the current real resolution
				'As otherwise there will be ugly graphical errors
				If RealHeight<GlowQuality Then
					If RealHeight<768
						GlowQuality=512
					End If
					If RealHeight<512
						GlowQuality=256
					End If
				End If
				If RealWidth<GlowQuality Then
					If RealWidth<768
						GlowQuality=512
					End If
					If RealWidth<512
						GlowQuality=256
					End If
				End If
		End Select
		
	Wend
	
	'Close the file stream
	CloseStream Ini_File
	
	'Parse input according to settings
	For Local i=1 To 10
		InputKey[i]=InputCache[i,InputMethod]
	Next

End Function

'-----------------------------------------------------------------------------
'Function DrawLogos() draws the game and producer logos
'-----------------------------------------------------------------------------
Function DrawLogos()
	Global PlayedSpark:Int
	
	Select IntroStep
	
		Case 1
			TreeLogo.Draw(ScreenWidth/2,ScreenHeight/2,1)
			IntroFade.Redraw()
			If IntroFade.Test()=False Then IntroStep:+1
			
		Case 2
			TreeLogo.Draw(ScreenWidth/2,ScreenHeight/2,1)
			IntroFade.Redraw()
			If FadeTimer=0 And IntroFade.FadeType=1 Then
				PlaySoundBetter Sound_Game_Logo,ScreenWidth/2,ScreenHeight/2,True,False
				FadeTimer=MilliSecs()
				'Print "bleep"
			End If
		
			If MilliSecs()-FadeTimer>450 And IntroFade.Test()=False And IntroFade.FadeType=1 Then
				IntroFade.ConvertToFadeOut()
				IntroFade.Start()
				FadeTimer=0
				'Print "bloop"
			End If
			
			
			If FadeTimer=0 And IntroFade.Test()=False Then PresentsFade.Start(); IntroStep:+1
		
		
		Case 3
			Local Flicker=0
			
			SetScale 1,1
			SetBlend Alphablend
			'SetImageFont DoubleBoldFont
			If Rand(1,50)>49 Then Flicker=Rand(1,2)
			DrawImage PresentStatic,ScreenWidth/2+9,ScreenHeight/2,Flicker
			If Flicker<>0 And MilliSecs()-PlayedSpark>110+Rand(0,30)
				PlaySoundBetter Sound_Game_Presents,ScreenWidth/2,ScreenHeight/2,True,False
				PlayedSpark=MilliSecs()
			End If
			'DoubleBoldFont.Draw  "PRESENTS",ScreenWidth/2,ScreenHeight/2-60, True
			
			PresentsFade.Redraw()
			If PresentsFade.Test()=False Then IntroStep:+1; PresentsFade.ConvertToFadeOut();  PresentsFade.Start()
		
		Case 4
			Local Flicker=0
			If PresentsFade.AlphaValue<.5 Then If Rand(1,50)>42 Then Flicker=Rand(1,2)
			SetScale 1,1
			SetBlend Alphablend
			'SetImageFont DoubleBoldFont
			'DoubleBoldFont.Draw "PRESENTS",ScreenWidth/2,ScreenHeight/2-60,True
			DrawImage PresentStatic,ScreenWidth/2+9,ScreenHeight/2,Flicker
			If Flicker<>0 And MilliSecs()-PlayedSpark>110+Rand(0,30)
				PlaySoundBetter Sound_Game_Presents,ScreenWidth/2,ScreenHeight/2,True,False
				PlayedSpark=MilliSecs()
			End If
			PresentsFade.Redraw()
			DoMusic()
			If PresentsFade.Test()=False Then
				MenuFade.Start()
				IntroStep:+1
				SetBlend AlphaBlend
				GameState=MENU
			End If
		
		Case 5
			'TStarField.UpdateAll()
			'Rock.UpdateAll()
			SetBlend AlphaBlend
			PresentStatic=Null
			'TStarField.DrawALl()
			'Rock.DrawAll()
			
			If MenuFade.Test()=False SetBlend ALPHABLEND
	
	End Select
	 
	If AnyInput() Then
		IntroFade.ConvertToFadeOut()
		IntroFade.FadeStart=False
		IntroFade.AlphaValue=0.0
		PresentsFade.FadeStart=False
		PresentsFade.AlphaValue=0.0
		IntroStep=5
		'MenuFade.ConvertToFadeOut()
		MenuFade.FadeStart=False
		MenuFade.AlphaValue=0.0
		GameState=MENU
		'PresentsFade.ConvertToFadeOut()
		TreeLogo.Remove()
		PresentStatic=Null
		PlayedSpark=Null
		FlushMouse()
		FlushKeys()
		
	End If
	
	
End Function

'-----------------------------------------------------------------------------
'Function WriteIniFile() saves the ini file to represent option changes
'-----------------------------------------------------------------------------
Function WriteIniFile()
	Local Old_Ini_File:TStream
	Local Ini_File:TStream
	Local New_Value:String
	Local Temp_File:Byte
	Local Temporary_String:String
	Local Temporary_Line:String
	Local Temporary_Value:String
	Local j:Int 

	'Synchronize Mouse and Mouse Relative inputs
	If InputMethod=2	
		For Local i=0 To 10
			InputCache[i,1]=InputCache[i,2]
		Next
	End If
	
	'See if we can get our hands on an inifile 
	?MacOS
	Local DirExists:Byte
	Local DirCreated:Byte
	
	'get the old ini file
	Try
		ChangeDir "./"
		DirExists=ChangeDir(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption")

		If Not DirExists
			DirCreated=CreateDir(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption")
		End If
		
		If Not DirCreated And DirExists=False Then Throw "NoDir"
		
	Catch NoDir$
		
		RuntimeError("Couldn't create directory:~n"+GetUserHomeDir()+"/Library/Application Support/Invaders Corruption")
		End
	
	End Try
	
	Old_Ini_File=OpenFile(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/settings.ini",True,False)
	
	If Not Old_Ini_File Then
		CopyFile  (GetBundleResource("settings.ini"),GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/settings.ini")
		Old_Ini_File=OpenFile(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/settings.ini",True,False)
	End If
	
	'Create the temporary ini file
	Try
		
		Temp_File=CreateFile(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/temp.ini")
		
		If Not Temp_file Throw "NoTempFile"
		
	Catch NoTempFile$
	
		Notify ("Temporary settings file can not be created, settings will not be retained.",True)
		
		'No Inifile? - Insert Defaulting routine here
		End

		
	End Try
	
	'See if we can write to the new temporary file
	Try
		

		Ini_File=WriteFile(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/temp.ini")
		
		If Not ini_file Throw "NoWriteTempFile"
		
	Catch NoWriteTempFile$
	
		Notify ("Temporary settings file can not be written, settings will not be retained.",True)
		
		'No Inifile? - Insert Defaulting routine here
		End

		
	End Try		
	?
	
	?Win32
	Try
		
		'Windows
		Old_Ini_File=OpenFile("settings.ini",True,False)
		
		If Not Old_Ini_File Throw "NoOldFile"
		
	Catch NoOldFile$
	
		Notify ("Settings.ini - File could not be opened, settings can not be retained.",True)
		
		'No Inifile? - Insert Defaulting routine here
		End

		
	End Try
	
	'See if we can create the new temporary file
	Try
		
		Temp_File=CreateFile("temp.ini")
		
		If Not Temp_file Throw "NoTempFile"
		
	Catch NoTempFile$
	
		Notify ("Temporary settings file can not be created, settings will not be retained.",True)
		
		'No Inifile? - Insert Defaulting routine here
		End

		
	End Try
	
	'See if we can write to the new temporary file
	Try
		

		Ini_File=WriteFile("temp.ini")
		
		If Not ini_file Throw "NoWriteTempFile"
		
	Catch NoWriteTempFile$
	
		Notify ("Temporary settings file can not be written, settings will not be retained.",True)
		
		'No Inifile? - Insert Defaulting routine here
		End

		
	End Try
	?
	
	While Not Eof(Old_Ini_File)
		'do ini file readout
		
		Temporary_Line=ReadLine(Old_Ini_File)
		Temporary_String=Temporary_Line
						
		'search for a trailing ; marking a comment and remove it
		j=Temporary_String.find(";")
		'did we find a comment - get rid of it
		If j<>-1
			Temporary_String=Temporary_String[..j]
		End If
		
		
		'search for the '=' sign as it devides declarer and value
		j=Temporary_String.find("=")
		
		'did we find an '='? otherwise j=-1
		If j<>-1
			Temporary_Value=Temporary_String[j+1..]				'get the value
			Temporary_String=Upper(Temporary_String[..j])		'get the declarer and UPcase it
		EndIf
		
		
		'now lets read out & set all those values
		Select Temporary_String
		
			Case "FULL_SCREEN"
				New_Value="FULL_SCREEN="+FullScreen
				WriteLine(ini_file,New_Value)
			
			Case "WIDESCREEN"
				New_Value="WIDESCREEN="+WideScreen
				WriteLine(ini_file,New_Value)	
				
			Case "V_SYNC"
				Local Vsync:Int
				If VerticalSync=-1
					Vsync=1
				Else
					Vsync=0
				End If
				New_Value="V_SYNC="+VSync
				WriteLine(ini_file,New_Value)
				
			Case "INPUT_METHOD"
				New_Value="INPUT_METHOD="+InputMethod
				WriteLine(ini_file,New_Value)
			
			Case "SOUND_VOLUME"
				New_Value="SOUND_VOLUME="+String(SoundVolInt)
				WriteLine(ini_file,New_Value)
						
			Case "MUSIC_VOLUME"
				New_Value="MUSIC_VOLUME="+String(MusicVolInt)
				WriteLine(ini_file,New_Value)
			
			Case "RANDOM_SEED"
				New_Value="RANDOM_SEED="+Seed
				WriteLine(ini_file,New_Value)
				
			Case "PARTICLE_DENSITY"
				New_Value="PARTICLE_DENSITY="+Int(ParticleMultiplier*100)
				WriteLine(ini_file,New_Value)
				
			Case "MOTION_BLUR"
				New_Value="MOTION_BLUR="+Int(MotionBlurEnable)
				WriteLine(ini_file,New_Value)
							
			Case "BACKGROUND_TYPE"
				If UseSeedStyle Then
					New_Value="BACKGROUND_TYPE=16"
				Else
					New_Value="BACKGROUND_TYPE="+Int(BackgroundStyle)
				End If
				WriteLine(ini_file,New_Value)
				
			Case "BACKBUFFER_RES"
				New_Value="BACKBUFFER_RES="+Int(GlowQuality)
				WriteLine(ini_file,New_Value)
				
			Case "BACKBUFFER_ENABLE"
				If FullScreenGlow<>-1
					New_Value="BACKBUFFER_ENABLE="+Int(FullScreenGlow)
					WriteLine(ini_file,New_Value)
				Else
					WriteLine(ini_file,Temporary_Line)
				End If
			Case "PURE_BLACKS"
				New_Value="PURE_BLACKS="+Int(PureBlacks)
				WriteLine(ini_file,New_Value)
			
			Case "AUDIO_MODE"
				If SoundMode=1
					New_Value="AUDIO_MODE=STEREO"
				Else
					New_Value="AUDIO_MODE=MONO"
				End If
				WriteLine(ini_file,New_Value)
				
			Case "CURSOR_TYPE"
				New_Value="CURSOR_TYPE="+CrossHairType
				WriteLine(ini_file,New_Value)
				
			Case "KB_MOVE_UP"
				New_Value="KB_MOVE_UP="+InputCache[MOVE_UP,0]
				WriteLine(ini_file,New_Value)
				
			Case "KB_MOVE_DOWN"
				New_Value="KB_MOVE_DOWN="+InputCache[MOVE_DOWN,0]
				WriteLine(ini_file,New_Value)
				
			Case "KB_MOVE_LEFT"
				New_Value="KB_MOVE_LEFT="+InputCache[MOVE_LEFT,0]
				WriteLine(ini_file,New_Value)

			Case "KB_MOVE_RIGHT"
				New_Value="KB_MOVE_RIGHT="+InputCache[MOVE_RIGHT,0]
				WriteLine(ini_file,New_Value)

			Case "KB_SHOOT_CANNON"
				New_Value="KB_SHOOT_CANNON="+InputCache[FIRE_CANNON,0]
				WriteLine(ini_file,New_Value)
				
			Case "KB_SHOOT_BOMB"
				New_Value="KB_SHOOT_BOMB="+InputCache[FIRE_BOMB,0]
				WriteLine(ini_file,New_Value)
				
			Case "M_MOVE_UP"
				New_Value="M_MOVE_UP="+InputCache[MOVE_UP,1]
				WriteLine(ini_file,New_Value)
				
			Case "M_MOVE_DOWN"
				New_Value="M_MOVE_DOWN="+InputCache[MOVE_DOWN,1]
				WriteLine(ini_file,New_Value)
				
			Case "M_MOVE_LEFT"
				New_Value="M_MOVE_LEFT="+InputCache[MOVE_LEFT,1]
				WriteLine(ini_file,New_Value)

			Case "M_MOVE_RIGHT"
				New_Value="M_MOVE_RIGHT="+InputCache[MOVE_RIGHT,1]
				WriteLine(ini_file,New_Value)

			Case "M_SHOOT_CANNON"
				New_Value="M_SHOOT_CANNON="+InputCache[FIRE_CANNON,1]
				WriteLine(ini_file,New_Value)
				
			Case "M_SHOOT_BOMB"
				New_Value="M_SHOOT_BOMB="+InputCache[FIRE_BOMB,1]
				WriteLine(ini_file,New_Value)

			Case "JOY_MOVE_UP"
				New_Value="JOY_MOVE_UP="+InputCache[MOVE_UP,3]
				WriteLine(ini_file,New_Value)
				
			Case "JOY_MOVE_DOWN"
				New_Value="JOY_MOVE_DOWN="+InputCache[MOVE_DOWN,3]
				WriteLine(ini_file,New_Value)
				
			Case "JOY_MOVE_LEFT"
				New_Value="JOY_MOVE_LEFT="+InputCache[MOVE_LEFT,3]
				WriteLine(ini_file,New_Value)

			Case "JOY_MOVE_RIGHT"
				New_Value="JOY_MOVE_RIGHT="+InputCache[MOVE_RIGHT,3]
				WriteLine(ini_file,New_Value)

			Case "JOY_SHOOT_CANNON"
				New_Value="JOY_SHOOT_CANNON="+InputCache[FIRE_CANNON,3]
				WriteLine(ini_file,New_Value)
				
			Case "JOY_SHOOT_BOMB"
				New_Value="JOY_SHOOT_BOMB="+InputCache[FIRE_BOMB,3]
				WriteLine(ini_file,New_Value)

			Case "DUO_MOVE_UP"
				New_Value="DUO_MOVE_UP="+InputCache[MOVE_UP,4]
				WriteLine(ini_file,New_Value)
				
			Case "DUO_MOVE_DOWN"
				New_Value="DUO_MOVE_DOWN="+InputCache[MOVE_DOWN,4]
				WriteLine(ini_file,New_Value)
				
			Case "DUO_MOVE_LEFT"
				New_Value="DUO_MOVE_LEFT="+InputCache[MOVE_LEFT,4]
				WriteLine(ini_file,New_Value)

			Case "DUO_MOVE_RIGHT"
				New_Value="DUO_MOVE_RIGHT="+InputCache[MOVE_RIGHT,4]
				WriteLine(ini_file,New_Value)

			Case "DUO_SHOOT_CANNON"
				New_Value="DUO_SHOOT_CANNON="+InputCache[FIRE_CANNON,4]
				WriteLine(ini_file,New_Value)
				
			Case "DUO_SHOOT_BOMB"
				New_Value="DUO_SHOOT_BOMB="+InputCache[FIRE_BOMB,4]
				WriteLine(ini_file,New_Value)
				
			Case "DUO_AIM_UP"
				New_Value="DUO_AIM_UP="+InputCache[AIM_UP,4]
				WriteLine(ini_file,New_Value)
				
			Case "DUO_AIM_DOWN"
				New_Value="DUO_AIM_DOWN="+InputCache[AIM_DOWN,4]
				WriteLine(ini_file,New_Value)
								
			Case "DUO_AIM_LEFT"
				New_Value="DUO_AIM_LEFT="+InputCache[AIM_LEFT,4]
				WriteLine(ini_file,New_Value)				

			Case "DUO_AIM_RIGHT"
				New_Value="DUO_AIM_RIGHT="+InputCache[AIM_RIGHT,4]
				WriteLine(ini_file,New_Value)
			
			Case "JOY_DEADZONE_ADJUST"
				New_Value="JOY_DEADZONE_ADJUST="+JoyDeadZoneAdjust
				WriteLine(ini_file,New_Value)
			
			Case "MOUSE_SENSIVITY"
				New_Value="MOUSE_SENSIVITY="+MouseSensivity
				WriteLine(ini_file,New_Value)
			
			Case "AUTOFIRE"
				New_Value="AUTOFIRE="+AutoFire
				WriteLine(ini_file,New_Value)
			
			Case "PLAYER_NAME"
				New_Value="PLAYER_NAME="+PlayerName
				WriteLine(ini_file,New_Value)
			
			Case "UNIQUE_ID"
				New_Value="UNIQUE_ID="+UniqueID
				WriteLine(ini_file,New_Value)
				
			Case "SCREEN_SHAKE"
				New_Value="SCREEN_SHAKE="+ScreenShakeEnable
				WriteLine(ini_file,New_Value)
			
			Case "SCREEN_WIDTH"
				New_Value="SCREEN_WIDTH="+RealWidth
				WriteLine(ini_file,New_Value)
				
			Case "SCREEN_HEIGHT"
				New_Value="SCREEN_HEIGHT="+RealHeight
				WriteLine(ini_file,New_Value)
				
			Case "FORCE_RES"
				New_Value="FORCE_RES="+ForceRes
				WriteLine(ini_file,New_Value)
				
			Default 
				WriteLine(ini_file,Temporary_Line)
			
		End Select
	Wend 
	
	CloseStream Ini_File
	CloseStream Old_Ini_File
	
	Try
	
	?MacOS
	'Mac OS X
	If Not DeleteFile(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/settings.ini") Throw "bleh"
	If Not RenameFile(GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/temp.ini",GetUserHomeDir()+"/Library/Application Support/Invaders Corruption/settings.ini") Throw "bleh"
	?
		
	?Win32
	'Windows
	If Not DeleteFile("settings.ini") Throw "bleh"
	If Not RenameFile("temp.ini","settings.ini") Throw "bleh"
	?
		
	Catch bleh$
	
		Notify ("Ini file could not be refreshed. Settings can not be retained.",True)
		
		'No Inifile? - Insert Defaulting routine here
		End
		
	End Try
	
End Function

'-----------------------------------------------------------------------------
'Function InitGraphics() checks and then initializes the Graphics display
'-----------------------------------------------------------------------------
Function InitGraphics(Force:Byte=False,FirstStart:Byte=False)
	Local BitTemp:Int
	Local ForceTemp:Int
	
	GCCollect()
	
	InitMouse()
	
	ForceTemp=Force
	If Force=False And FullScreen=False Force=True
	
	If ForceRes=False And Force=False
		If DWidth<RealWidth
			RealWidth=800
			RealHeight=600
		ElseIf DWidth<800
			RealHeight=480
			RealWidth=640
		End If
		
		If DHeight<RealHeight
			RealHeight=600
			RealWidth=800
		ElseIf DHeight<600
			RealHeight=480
			RealWidth=640
		End If
	End If
	'set the graphics driver according to user selection
	If FirstStart
		Select GraphicsDriver
			?Win32
			Case 1
				SetGraphicsDriver D3D7Max2DDriver()
				GlLines=False
				FullScreenGlow=-1
			?
			Case 2
				SetGraphicsDriver GLMax2DDriver()
				
			Default
				SetGraphicsDriver GLMax2DDriver()
		End Select
	
		'does the user have 3d acceleration at all ?
		If Not(CountGraphicsModes()) Then
			Notify ("No 3D capable hardware found.~nPlease check your hardware and/or update your drivers.",True)
			End
		End If
	End If
	'this is the way blitz does it and we'll have to accomodate that
	BitTemp=BitDepth
	If FullScreen=0 Then BitTemp=0
	'can we init the given graphics mode ?
	If ForceRes=False And Force=False Then
		If GraphicsModeExists (RealWidth,RealHeight,BitTemp) Then
			'Close the current Graphics Object
			'Generate the actual resolution graphics display
			GraphicsWindow=Graphics (RealWidth,RealHeight,BitTemp,RefreshRate)
			'Set the virtual resolution according to the constants
			GraphicInfo = TMax2dGraphics.Current()
			'Grab Current Graphic Info
			
			'SetVirtualResolution(ScreenWidth,ScreenHeight)
			
			?Win32
			If PureBlacks=True
				SetAspectColor 0,0,0
			Else
				SetAspectColor 5,5,5
			End If
			SetAspectResolution ScreenWidth,ScreenHeight
			SwitchAspectMode ASPECT_STRETCH 'ASPECT_LETTERBOX_BORDER
			?
			
			'SetVirtualResolution(ScreenWidth,ScreenHeight)
	
		Else
			Local NoGraphics:Byte
			NoGraphics=Confirm ("Unable initalize specified graphics mode.~nRestore default resolution?",True)
			If NoGraphics
				If WideScreen
					If RecommendedWideWidth=0 And RecommendedWideHeight=0 Then
						WideScreen=False
						RealWidth=RecommendedTallWidth
						RealHeight=RecommendedTallHeight
					Else
						RealHeight=RecommendedWideHeight
						RealWidth=RecommendedWideWidth
					End If	
				Else
					If RecommendedTallWidth=0 And RecommendedTallHeight=0 Then
						WideScreen=True
						RealWidth=RecommendedWideWidth
						RealHeight=RecommendedWideHeight
					Else
						RealWidth=RecommendedTallWidth
						RealHeight=RecommendedTallHeight
					End If
				End If
				FullScreen=False
				InitGraphics()
				Return
			Else
				End
			End If
		End If
	Else
		GraphicsWindow=Graphics(RealWidth,RealHeight,BitTemp,RefreshRate)
		
		GraphicInfo = TMax2dGraphics.Current()
		'Grab Current Graphic Info
		
		'SetVirtualResolution(ScreenWidth,ScreenHeight)
		
		?Win32
		If PureBlacks=True
			SetAspectColor 0,0,0
		Else
			SetAspectColor 5,5,5
		End If
		SetAspectResolution ScreenWidth,ScreenHeight
		SwitchAspectMode ASPECT_STRETCH
		?
			
	End If
	
	?MacOs
	SetVirtualResolution(ScreenWidth,ScreenHeight)
	?
	
	'Make sure that the GLOW fits within the current real resolution
	'As otherwise there will be ugly graphical errors
	If RealHeight<GlowQuality Then
		If RealHeight<768
			GlowQuality=512
		End If
		If RealHeight<512
			GlowQuality=256
		End If
	End If
	If RealWidth<GlowQuality Then
		If RealWidth<768
			GlowQuality=512
		End If
		If RealWidth<512
			GlowQuality=256
		End If
	End If
	
	If PureBlacks=True
		SetClsColor(0,0,0)
		ClsColor=$FF000000
	Else
		SetClsColor(5,5,5)
		ClsColor=$FF050505
	End If
	
	'Initialize Render2Texture
	tRender.Init()
	tRender.Cls
	BloomFilter:TImage = tRender.Create(GlowQuality,GlowQuality) 
	Cls
	
	MainMenu.ResetAlpha()
	
	InitMouse()
	
	MainMenu.OptionX=ScreenWidth/2-387'332-55
	
	?Win32
	InitW32()
	Local Extension:String=Right(AppFile,4)
	SetIcon((StripAll(AppFile)+Extension), GetActiveWindow())
	'FindDuplicateInstances()
	?
	
	GCCollect()
	'FixedRateLogic.SetFPS(200)
	FixedRateLogic.CalcMS()
	FixedRateLogic.HistoryClear()
	FixedRateLogic.Init()
	'If we made it this far we can safely force the res
	If Force And ForceTemp Then ForceRes=1
		
End Function 

'-----------------------------------------------------------------------------
'Function DoEventHooks() checks if the window is closed, suspended etc...
'-----------------------------------------------------------------------------
Function DoEventHooks()
	
	'did we loose focus - keep track of that to avoid huge jumps in delta
	If AppSuspended() And Logic_LostFocus=False Then
		Logic_LostFocus=True
		If GameState=MENU InitMouse()
		'Pause the Game
		If GameState=PLAYING
			AutoPause=True
			If Not FullScreen ShowMouse()
			'If FullScreen=0 Then ReInitGraphics=True
			'InitGraphics()
			GunPickupPause=MilliSecs()-Player.LastGunPickup
			If Player.HasSlowmotion<>-1 Then
				RemainingSlowMo=Player.HasSlowMotion-MilliSecs()
			End If
			If Player.HasBounce<>0 Then
				HasBouncyShotPause=Player.HasBounce-MilliSecs()
			End If
			If Player.HasSuper<>0 Then
				HasSuperShotPause=Player.HasSuper-MilliSecs()
			End If
			If FrenzyMode<>0 Then
				HasFrenzyPause=FrenzyMode-MilliSecs()
			End If
			If WipeOutOnce<>0
				WipeOutOncePause=WipeOutOnce-MilliSecs()
			End If
			DifficultyUpgradePause=MilliSecs()-LastDifficultyChange
			PreviousFPS=FixedRateLogic.FrameRate
			FixedRateLogic.SetFPS(0)
			FixedRateLogic.CalcMS()
			GameState=PAUSE
			PauseSecs=MilliSecs()
			PreviousSoundMute=SoundMute
			SoundMute=1
		End If
	End If
	
	'did we regain focus ? adjust game timing accordingly
	If AppSuspended()=False And Logic_LostFocus=True Then
		
		'Workaround for openGL minimize
		If GraphicsDriver = 2 And WindowMinimized = True Then
			SetGraphics GraphicsWindow
			WindowMinimized=False
		End If
		'here we re-init the delta timing to fix small hitches
		If FullScreen=0 ReInitGraphics=True'InitGraphics()
		FixedRateLogic.CalcMS()
		FixedRateLogic.Init()
		Logic_LostFocus=False
		'Flush Mouse and Keys to Avoid Click-Ins
		FlushMouse()
		FlushKeys()
		
		'HideMouse()
		
		'CenterMouseX=GraphicsWidth()/2
		'CenterMouseY=GraphicsHeight()/2
		
		'MouseXSpeed = 0
		'MouseYSpeed = 0
		
		'If FullScreen
		'	MoveMouse(CenterMouseX,CenterMouseY)
		'Else
		'	MoveMouse(DWidth/2,DHeight/2)
		'End If

		'prevMouseX=MouseX()
		'prevMouseY=MouseY()
		
	End If
	
	'immediate exit on clicking X
	If AppTerminate() Then ExitCode=True
	
	'is the mouse in the window - hide and show accordingly
	'also poll if the window was resized to the taskbar this is needed for the opengl fix
	Select PollEvent()
	
		Case EVENT_MOUSELEAVE ShowMouse()
		
		Case EVENT_WINDOWSIZE ExitCode=True
		
		Case EVENT_MOUSEENTER If GameState<>PAUSE Then InitMouse()
		
		Case 257 WindowMinimized=True

	End Select

End Function

'----------------------------------------------------------------------------------------------
'Function DebugKeys() Polls certain keys, when in debug mode and makes the player invincible
'----------------------------------------------------------------------------------------------
Rem
Function DebugKeys()
	
	If TYPING=False And KeyHit(KEY_1)
		
		Player.Invincible=1-Player.Invincible

	End If
	
	If TYPING=False And KeyHit(KEY_7)
		Player.HasSlowMotion=MilliSecs()+10000
	End If
	
	Rem
	If TYPING=False And KeyHit (KEY_2) Then SpawnBlock=1-SpawnBlock
	
	If TYPING=False And KeyHit(KEY_3)
		SoundMode=1-SoundMode
	End If
	
	If TYPING=False And KeyHit(KEY_4)
		SoundPitching=1-SoundPitching
	End If
	
	If TYPING=False And KeyHit(KEY_5)
		ShootingSounds=1-ShootingSounds
		'Player.HasCannon=True
	End If
	
	If TYPING=False And KeyHit(KEY_6)
		ExplosionSounds=1-ExplosionSounds
	End If
	
	
	If TYPING=False And KeyHit(KEY_8) Then
		TensionSounds=1-TensionSounds
	End If
	
	If TYPING=False And KeyHit(KEY_9) Then
		'MusicPlayer.Request("GAMEOVER")
		ShowHUD=1-ShowHUD
		'ScanLineFader=.45
		'Difficulty:+1
		'Player.Immolation=True
	End If
	End Rem
	Rem
	If TYPING=False And KeyHit(KEY_MINUS)
		Score:+40000
		Player.HasSuper:+MilliSecs()+10000
	End If
	'Debug
	
	If TYPING=False And KeyHit(KEY_0) Player.HasBomb=3; Player.HasShield=2; Player.HasShot=3

End Function
End Rem
'-----------------------------------------------------------------------------
'Function DrawCursor() draws and animates (color cycles) the mouse cursor
'-----------------------------------------------------------------------------
Function DrawCursor()

	Global PlayedTooltipSound:Byte
	Global OldTooltip:String
	
	'Size up Crosshair
	Local SizeUpX:Float
	Local SizeUpY:Float
	
	'Size up the cursor & tooltips for resolutions smaller than 1024x768
	If RealWidth>=1024 And RealHeight>=768
		SetTransform 0,1,1
		SizeUpX=0
	Else
		If WideScreen
			SizeUpX=1280/Float(RealWidth)
			SizeUpY=768/Float(RealHeight)
			SizeUpX=(SizeUpX+SizeUpY)/2
		Else
			SizeUpX=1024/Float(RealWidth)
			SizeUpY=768/Float(RealHeight)
			SizeUpX=(SizeUpX+SizeUpY)/2
		End If
		'Print SizeUpX
		SetTransform 0,SizeUpX,SizeUpX
	End If
	SetAlpha 1
	SetBlend ALPHABLEND
	

	If CrossHairType>6
		'If GameState<>Pause CycleColors(6*(1-Delta))
		SetColor RCol,GCol,BCol
		DrawImage MouseCursor,XMouse,YMouse, CrossHairType-7
		SetColor 255,255,255
	Else
		DrawImage MouseCursor,XMouse,Ymouse, CrossHairType-1
	End If	
	If OldToolTip<>ToolTip Then
		OldToolTip=ToolTip
		PlayedToolTipSound=False
	End If

	If ToolTip<>"" Then
		Local TempSeed:String
		Local TempTip:String
		Local FirstHyphen:Int
		Local SecondHyphen:Int
		
		'OldTooltip=ToolTip
		SetAlpha 0.85
		SetColor 35,35,35
		'SetScale SizeUpX,SizeUpX
		SetScale 1,1
		DrawRect XMouse+12,YMouse+2,IngameFont.StringWidth(ToolTip)/2+10,18
		'SetScale SizeUpX/2,SizeUpX/2
		SetScale .5,.5
		SetAlpha 1
		SetColor 255,255,255
		IngameFont.Draw ToolTip,XMouse+18,YMouse+4,False,False,True,True
		FirstHyphen=Instr(ToolTip,"'",1)
		SecondHyphen=Instr(ToolTip,"'",FirstHyphen+1)
		SetColor 255,255,0
		If ToolTip<>"Score has no Seed" And Instr(ToolTip,"% ",1)=0
			If FirstHyphen>16
				IngameFont.Draw Mid$(ToolTip,FirstHyphen+1,SecondHyphen-(FirstHyphen+1)),XMouse+185,YMouse+4,False,False,True,True
			ElseIf FirstHyphen<16
				IngameFont.Draw Mid$(ToolTip,FirstHyphen+1,SecondHyphen-(FirstHyphen+1)),XMouse+148,YMouse+4,False,False,True,True
			End If
		End If
		If Instr(ToolTip,"% ",1)
			IngameFont.Draw FloatRound(SeedDifficultyJudge,1)+"% ",XMouse+191.2,YMouse+4,False,False,True,True
		End If
		SetColor 255,255,255
		SetScale 1,1
		If PlayedToolTipSound=False
			PlayedToolTipSound=True
			PlaySoundBetter Sound_Menu_Hover,FieldWidth/2,FieldHeight/2,False,False
		End If
	End If
	SetTransform 0,1,1
	
End Function
'-------------------------------------------------------------------------------------
'Function DrawHelp() renders the Help Screen
'-------------------------------------------------------------------------------------
Global HelpRot:Float=0;
Function DrawHelp()
	
	Local Introduction:String[7], Spinnertext:String[5], InvaderText:String[3], FragmentText:String[3]
	
	Local GoodGuys:String[32]
	Local GoodGuys2:String[32]
	
	Local GoodMark:String[19]
	Local GoodMark2:String[31]

	Local WideOffset:Int
	Local WideOffset2:Int
	If WideScreen
		WideOffset=75
		WideOffset2=175
	Else
		WideOffset=0
		WideOffset2=0
	End If
	'Introduction[0]="After decades of being blasted away in millions at arcades, the invaders turned sentient."
	'Introduction[1]="Already having infested all known global networks, they are now trying to access the computer"
	'Introduction[2]="containing their source, allowing them to alter themselves further, giving them untold power."
	'Introduction[3]="An expert player was chosen to merge with the firewall program - forming the last line of defense..."
	'Introduction[4]=""
	

	GoodMark[6]="::CANNON [PERMANENT]"
	GoodMark[18]="::Rate of fire [PERMANENT]"
	GoodMark2[0]="::Shot Speed [PERMANENT]"
	GoodMark2[12]="::ENGINE BOOST [PERMANENT]"
	GoodMark2[24]="::Bomb [PERMANENT]"
	GoodMark2[30]="::Shield [PERMANENT]"

	
	GoodGuys[0]="::The Player's Ship"
	GoodGuys[1]=";;That's you!"
	GoodGuys[6]="::CANNON"
	GoodGuys[7]=";;Increases your firepower"
	GoodGuys[12]="::BOUNCY SHOT"
	GoodGuys[13]=";;Shots bounce off obstacles"
	GoodGuys[18]="::Rate of fire"
	GoodGuys[19]=";;Increases the rate of fire"
	GoodGuys[24]="::Super Shot"
	GoodGuys[25]=";;Shots pierce most enemies"
	GoodGuys[30]="::Super Bounce Shot"
	GoodGuys[31]=";;Bounce- and Super-shot"
	
	GoodGuys2[0]="::Shot Speed"
	GoodGuys2[1]=";;Your shots fly faster"
	GoodGuys2[6]="::TIME STRETCH"
	GoodGuys2[7]=";;Slows down time"
	GoodGuys2[12]="::ENGINE BOOST"
	GoodGuys2[13]=";;Makes you more agile"
	GoodGuys2[18]="::IMMOLATION"
	GoodGuys2[19]=";;Fire from all directions"
	GoodGuys2[24]="::BOMB"
	GoodGuys2[25]=";;Clears the screen"
	GoodGuys2[30]="::Shield"
	GoodGuys2[31]=";;Protects + can be upgraded"
	
	
	Select InputMethod
		Case 0
			Introduction[0]="Use The keyboard to move and shoot."
			Introduction[1]="Move: "+KeyNames[InputKey[1]]+","+KeyNames[InputKey[2]]+","+KeyNames[InputKey[3]]+","+KeyNames[InputKey[4]]+" Fire: "+KeyNames[InputKey[5]]+" Bomb: "+KeyNames[InputKey[6]]
		Case 2
			Introduction[0]="Use the mouse to aim, keyboard to move in the cursor's direction."
			Introduction[1]="Move: "+KeyNames[InputKey[1]]+","+KeyNames[InputKey[2]]+","+KeyNames[InputKey[3]]+","+KeyNames[InputKey[4]]+" Fire: "+KeyNames[InputKey[5]]+" Bomb: "+KeyNames[InputKey[6]]
		Case 1
			Introduction[0]="Use the mouse to aim, the keyboard to move."
			Introduction[1]="Move: "+KeyNames[InputKey[1]]+","+KeyNames[InputKey[2]]+","+KeyNames[InputKey[3]]+","+KeyNames[InputKey[4]]+" Fire: "+KeyNames[InputKey[5]]+" Bomb: "+KeyNames[InputKey[6]]
		Case 3
			Introduction[0]="Use your joystick or joypad to move and shoot."
			Introduction[1]="Make sure to define the control layout first!"
		Case 4
			Introduction[0]="Use your dual-analog joypad to move and shoot."
			Introduction[1]="Make sure to define the control layout first!"
		End Select

	Introduction[3]="For HI-Score: Fly in a risky way, use a difficult seed, gain maximum multiplier."
	Introduction[4]="Upon triggering a special its name is shown, adding score and frenzy-points."
	Introduction[5]="When the frenzy-bar is full, time slows and your points-multiplier doubles."
	
	
	If SoundMute
		Spinnertext[0]="F11 - Toggle Sound + Music (MUTED)"
	Else
		Spinnertext[0]="F11 - Toggle Sound + Music (ON)"
	End If
	If FullScreen
		Spinnertext[1]="F10 - Toggle Windowed mode"
	Else
		Spinnertext[1]="F10 - Toggle Fullscreen mode"
	End If
	Spinnertext[2]="F8 - Take Screenshot (PNG File)"
	If AutoFire
		Spinnertext[3]="F7 - Toggle Auto-Fire (ON)"
	Else
		Spinnertext[3]="F7 - Toggle Auto-Fire (OFF)"
	End If
	Spinnertext[4]="P - Toggle Pause" 
	
	InvaderText[0]="Design, Direction, Code - Manuel van Dyck"
	InvaderText[1]="Music Composer - Carlo Castellano"
	InvaderText[2]="Sound FX - John Nesky"
	
	'FragmentText[0]="Appear in small clusters, floating through the core-memory."
	'FragmentText[1]="These fragile network packets are not confined to borders"
	'FragmentText[2]="or boundaries, trying to find their lost destination - forever."
	
	DarkenScreen(.955)
	
	If CrossHairType<=6
		If GameState<>Pause CycleColors(1*Delta)
	End If
	
	If HelpToggle
		Player.HelpScreen(120+WideOffset,150,0,HelpRot)
		PowerUp.HelpScreen(120+WideOffset,245,0,HelpRot)
		PowerUp.HelpScreen(120+WideOffset,340,2,HelpRot)
		PowerUp.HelpScreen(120+WideOffset,435,3,HelpRot)
		PowerUp.HelpScreen(120+WideOffset,528,4,HelpRot)
		PowerUp.HelpScreen(120+WideOffset,625,10,HelpRot)
		PowerUp.HelpScreen(580+WideOffset2,150,1,HelpRot)
		PowerUp.HelpScreen(580+WideOffset2,245,7,HelpRot)
		PowerUp.HelpScreen(580+WideOffset2,340,8,HelpRot)
		PowerUp.HelpScreen(580+WideOffset2,435,9,HelpRot)
		PowerUp.HelpScreen(580+WideOffset2,528,6,HelpRot)
		PowerUp.HelpScreen(580+WideOffset2,625,5,HelpRot)
	End If
	
	'MineLayer.Preview (150,650,5)
	'Mine.Preview (550,200,5)
	'Chaser.Preview (550,350,5)
	'Boid.Preview (550,500,5)
	'Snake.Preview (550,650,5)
	
	BoldFont.Draw "INVADERS CORRUPTION VER. 1.2.8",ScreenWidth/2,55,True

	
	'Spinner.Preview (43,420,NextInvader)
	If WideScreen = 0
		Invader.Preview (193,69,NextInvader)
		Invader.Preview (827,69,NextInvader)
	ElseIf WideScreen = 1
		Invader.Preview (308,69,NextInvader)
		Invader.Preview (967,69,NextInvader)
	End If
	'Asteroid.Preview (43,660,NextInvader)
	
	'SetScale .75,.75
	'BoldFont.Draw "SPINNER",80,410
	'BoldFont.Draw "INVADER",80,530
	'BoldFont.Draw "DATA FRAGMENT",80,650

	
	
	
	If HelpToggle=1
		SetAlpha 0.75
		SetScale .75,.75
		SetColor 55,55,55
		BoldFont.DrawStringArray GoodMark,165+WideOffset,129,False,False,False,False,16
		BoldFont.DrawStringArray GoodMark2,625+WideOffset2,129,False,False,False,False,16
		SetColor 255,255,255
		BoldFont.DrawStringArray GoodGuys,165+WideOffset,129,False,False,False,False,16
		BoldFont.DrawStringArray GoodGuys2,625+WideOffset2,129,False,False,False,False,16
	Else
		SetAlpha 1
		BoldFont.Draw "USEFUL SHORTCUTS",ScreenWidth/2,290,True
		BoldFont.Draw "DEVELOPER CREDITS",ScreenWidth/2,490,True
		SetScale .75,.75
		BoldFont.DrawStringArray Introduction,ScreenWidth/2,110,True
		SetColor 255,0,0
		SetColor 255,255,255
		BoldFont.DrawStringArray Spinnertext,ScreenWidth/2,350,True
		BoldFont.DrawStringArray InvaderText,ScreenWidth/2,550,True
	End If
	SetAlpha .25
	BoldFont.Draw ("Click to toggle between pages; ESC to return Main Menu!",ScreenWidth/2,690,True)
	SetAlpha 1
	SetScale 1,1
	
End Function

'-------------------------------------------------------------------------------------
'Function ProcessHelp() does the calculations for the Help Screen
'-------------------------------------------------------------------------------------
Function ProcessHelp()
	
	HelpRot:+.2*Delta
	
	If MilliSecs()-LastSwitch>1450
			NextInvader:+1
			LastSwitch=MilliSecs()
	End If
	If nextInvader>=45 Then nextinvader=1
	
	If MouseHit(1)
		HelpToggle=1-HelpToggle
		PlaySoundBetter Sound_Menu_Click,ScreenWidth/2,ScreenHeight/2,False,False
	End If
	
End Function

'-------------------------------------------------------------------------------------
'Function GetRandSeed() gets the random seed for the game and re-seeds if neccessary
'-------------------------------------------------------------------------------------
Function GetRandSeed(FirstTime:Int,JustSeed:Int=False)
	Local SoundPlay:Byte
	Keen4E=False
	ToolTip=""
	'Store the Old Backgroundstyle in case we change it
	
	If Seed="" Or FirstTime=False And JustSeed=False Then 
		Local InputString:String=Seed
		Local AbortCode:Int
		
		While Not AbortCode
			Cls
			SoundPlay=True
			SetColor 255,255,255
			SetBlend ALPHABLEND
			SetScale 2,2
			If FirstTime
				BoldFont.Draw "SPECIFY A CORE-SEED",ScreenWidth/2,ScreenHeight/2-290,True
			Else
				BoldFont.Draw "YOUR CURRENT CORE-SEED",ScreenWidth/2,ScreenHeight/2-290,True	
			End If
			SetColor 200,200,10
			SetScale 1,1
			BoldFont.Draw "THIS IS NOT YOUR PLAYER NAME",ScreenWidth/2,ScreenHeight/2-240,True
			SetColor 255,255,255
			SetScale 1,1
			GetInput ScreenWidth/2,ScreenHeight/2-70,InputString,24
			SetScale .75,.75
			If InputString<>""
				SetAlpha 0.7
				BoldFont.Draw "SEED DIFFICULTY : "+FloatRound(SeedDifficultyJudge,1)+"%",ScreenWidth/2,ScreenHeight/2,True
				SetAlpha 0.45
				If ScoreMultiplier>=.122 And ScoreMultiplier<=.127
					BoldFont.Draw "BASE MULTIPLIER : x"+FloatRound(ScoreMultiplier,3),ScreenWidth/2,ScreenHeight/2+30,True
				Else
					BoldFont.Draw "BASE MULTIPLIER : x"+FloatRound(ScoreMultiplier,2),ScreenWidth/2,ScreenHeight/2+30,True
				End If
			Else
				SetAlpha 0.35
				BoldFont.Draw "SEED DIFFICULTY : --.-%",ScreenWidth/2,ScreenHeight/2,True
				SetAlpha 0.2
				BoldFont.Draw "BASE MULTIPLIER : -.--",ScreenWidth/2,ScreenHeight/2+30,True
			End If
			SetScale 1,1
			SetAlpha 0.65
			BoldFont.Draw "ENTER WHATEVER YOU WANT. YOUR SEED WILL BE USED TO",ScreenWidth/2,ScreenHeight/2+120,True
			BoldFont.Draw "DETERMINE THE LOOK AND BEHAVIOUR OF THIS GAME.",ScreenWidth/2,ScreenHeight/2+150,True
			SetAlpha 0.5
			SetScale .75,.75
			SetColor 195,195,195
			BoldFont.Draw "ENTER NO TEXT TO GENERATE A RANDOM CORE-SEED.",ScreenWidth/2,ScreenHeight/2+270,True
			BoldFont.Draw "SUBMITTING YOUR SCORE ONLINE MAKES THIS SEED VISIBLE TO OTHERS!",ScreenWidth/2,ScreenHeight/2+240,True
			SetAlpha 1
			SetColor 255,255,255
			
			If InputString<>""
				Local SeedTempVal:Int
				For Local i=1 To Len(InputString)
					SeedTempVal:+Asc(Mid$(InputString,i,1))*(i/2)
				Next
		
				SeedRnd (SeedTempVal)
				RandomGain=Rnd(-.08,0.115)
				SeedDifficultyChange=Rnd(0.82,1.15)
				SeedDifficultyJudge=Abs(100-((SeedDifficultyChange-.82)/.43)*100)
				SeedDifficultyJudge:+(((RandomGain+.08)/.195)*100)*2 'Enemy speed is weighted x2
				SeedDifficultyJudge:/3
				Local SeedTest:String=SeedJumble(InputString)
				If SeedTest="RIQO>SFLIBK@B"
					SeedDifficultyJudge=666.00
				End If
					
				If SeedTest="EROQJBMIBKQV"
					SeedDifficultyJudge=101.00
				End If
				
				If SeedDifficultyJudge<=20
					ScoreMultiplier=.125
				Else If SeedDifficultyJudge<=30
					ScoreMultiplier=.25
				Else If SeedDifficultyJudge<=45
					ScoreMultiplier=.5
				Else If SeedDifficultyJudge<=55
					ScoreMultiplier=.75
				Else If SeedDifficultyJudge<=65
					ScoreMultiplier=1.0
				Else If SeedDifficultyJudge<=85
					ScoreMultiplier=1.25
				Else If SeedDifficultyJudge<=95
					ScoreMultiplier=1.5
				Else
					ScoreMultiplier=1.75
				End If
				
				Trk_Mul = SeedJumble(String(ScoreMultiplier),False,False)
				
			End If
			
			If KeyHit(KEY_ESCAPE)

				
				If FirstTime
					AbortCode=True
					ExitCode=True
					End
				Else
					InputString=Seed
					AbortCode=True
				End If
			End If
			
			If AppTerminate() Then
				If FirstTime
					'EndCleanUp()
					End 
				Else
					ExitCode=True
					AbortCode=True
				End If
			End If
			
			?MacOS
			If KeyDown(KEY_LSYS) Or KeyDown(KEY_RSYS) And KeyDown(KEY_Q) Then
				If FirstTime
					'EndCleanUp()
					End 
				Else
					ExitCode=True
					AbortCode=True
				End If
			End If
			?
	
			?Win32
			If KeyDown(KEY_LALT) Or KeyDown(KEY_RALT) And KeyDown(KEY_F4) Then
				If FirstTime
					'EndCleanUp()
					End 
				Else
					ExitCode=True
					AbortCode=True
				End If
			End If
			?
			If KeyHit(KEY_ENTER)
				AbortCode=True
			
				If InputString=""
					SeedRnd MilliSecs()/2
				
					For Local i=1 To Rnd(3,15)
						InputString:+Chr(Rand(65,90))
					Next
				End If
				AbortCode=True
			End If
			
			Flip
		Wend
		
		'Only Regenerate when we need to, there is the possibility that the player was just checking the seed
		If Seed<>InputString
			Seed=InputString
		Else
			Cls
			FlushKeys()
			FlushMouse()
			MainMenu.Optionlevel=1
			Return
		End If
	End If
	
	Local SeedVal:Int
	Local SeedTest:String =SeedJumble(Seed)
	
	NoExplode=0
	
	If SeedTest.Contains("KL?LLJ") Then
		NoExplode=1
	End If
	
	For Local i=1 To Len(Seed)
		SeedVal:+Asc(Mid$(Seed,i,1))*(i/2)
	Next
	
	SeedRnd (SeedVal)
	RandomGain=Rnd(-.08,0.115)
	SeedDifficultyChange=Rnd(0.82,1.15)
	SeedRnd (SeedVal)
	
	If Not FirstTime
		'Remove Everything
		TypeDestroy(True)
	End If
	
	'Local Malloc:Int=GCMemAlloced()
	'Print SeedTest
	
	If FirstTime
		If SeedTest="@LJJ>KABOHBBK" Or SeedTest="HBBK1B" Or SeedTest="HBBK1B"
			If SoundPlay PlaySoundBetter Sound_Keen,ScreenWidth/2,ScreenHeight/2,False,False
			Keen4E=True
		End If
		
		If SeedTest="RIQO>SFLIBK@B"
			RandomGain=.42
			If SoundPlay PlaySoundBetter Sound_Ultra,ScreenWidth/2,ScreenHeight/2,False,False
			SeedDifficultyJudge=666.00
		End If
			
		If SeedTest="EROQJBMIBKQV"
			RandomGain=.34
			If SoundPlay PlaySoundBetter Sound_Ultra,ScreenWidth/2,ScreenHeight/2,False,False
			SeedDifficultyJudge=101.00
		End If
		
		If SeedTest="@>Q@E//"
			PlayerName="YOSSARIAN LIVES"
		End If
		
		If SeedTest="P>IFKDBO"
			PlayerName="HOLDEN CAULFIELD"
		End If
		
		If SeedTest="QEBA>OHQLTBO"
			PlayerName="ROLAND"
		End If
		
		If SeedTest=">MMIBFF" Or SeedTest="@LJJLALOBPRMBOMBQ" Or SeedTest=">MMIBFFB" Or SeedTest="@LJJLALOBMBQ" Or SeedTest="EB>QEHFQE56" Or SeedTest="PFOFRP." Or SeedTest="SF@QLO6---"
			EasterEgg=True
			'InitGraphics()
		ElseIf SeedTest.Contains("?I>@H") And SeedTest.Contains("TEFQB")
			EasterEgg=2
		ElseIf SeedTest.Contains("PEFOL") And SeedTest.Contains("HROL")
			EasterEgg=2
		ElseIf SeedTest.Contains("KLFO") And SeedTest.Contains("?I>K@")
			EasterEgg=2
		Else
			EasterEgg=0
		End If
		Invader.Generate(1)
		
	End If
	
	If Not FirstTime
		
		If SeedTest=">MMIBFF" Or SeedTest="@LJJLALOBPRMBOMBQ" Or SeedTest=">MMIBFFB" Or SeedTest="@LJJLALOBMBQ" Or SeedTest="EB>QEHFQE56" Or SeedTest="PFOFRP." Or SeedTest="SF@QLO6---"
			EasterEgg=True
			BackgroundStyle=3
			GlowQuality=256
			ReInitGraphics=True
			'InitGraphics()
		ElseIf SeedTest.Contains("?I>@H") And SeedTest.Contains("TEFQB")
			EasterEgg=2
		ElseIf SeedTest.Contains("PEFOL") And SeedTest.Contains("HROL")
			EasterEgg=2
		ElseIf SeedTest.Contains("KLFO") And SeedTest.Contains("?I>K@")
			EasterEgg=2
		ElseIf SeedTest = "LIAP@ELLI"
			BackgroundStyle=6
			Player.TwinEngine=False
			EasterEgg=0
		Else
			EasterEgg=0
		End If
		Invader.Generate(1)
		ChangedSeedRecently=True
		
		'Zero out background colors, so they get regenerated
		UpRising.RGB[0]=0
		BoxedIn.RGB[0]=0
		GridHit.RGB[0]=0
		
		'Set the Option menu to the base level
		MainMenu.OptionLevel=1
		GAMESTATE=MENU
		'Remove any input from the queue
		FlushMouse()
		FlushKeys()

		GCSuspend()
		Cls
		SetColor 255,255,255
		'Show what we are doing - regenerating..
		Invader.Preview ScreenWidth/2-105,ScreenHeight/2,1
		BoldFont.Draw "Re-Seeding...",ScreenWidth/2+20,ScreenHeight/2-15,True
		Flip
		Delay (175)
				
		'Render our generative Logo, we have to do this for the RND generator's consistencys sake
		TreeLogo.Render(True)
		
		Local Trash:Byte
		'Regenerate All Graphics
		Squared.Generate(ScreenWidth,ScreenHeight)
		Background.Generate(ScreenWidth,ScreenHeight)
		'Print "Point 0."+Int(GCMemAlloced()-Malloc)
		
		Invader.Generate(150)
		Spinner.Generate(150)
		Snake.Generate(65)
		Chaser.Generate(55)
		Minelayer.Generate(30)
		Mine.Generate(30)
		Asteroid.Generate(45)
		Boid.Generate(40)
		Player.Generate()
		'DataNode.Generate(15)
		Thief.Generate(55)
		Shot.Generate()
		
		'Print "Point 1."+Int(GCMemAlloced()-Malloc)
		
		GameOfLife.Init()
		TStarfield.Init(256)
		GridHit.Generate(ScreenWidth,ScreenHeight)
		Corruption.Generate(ScreenWidth,ScreenHeight,35)
		CorruptionNode.Generate(23)
		CorruptedInvader.Generate(55)
		'RandomGain=Rnd(-.08,0.115)
		Trash=Rnd(-.08,0.115)
		SetupKeyTable()

		MainMenu.Init()
		
		ShotGhost.RegetImage()
		'ParticleManager.Init()
		MotionBlur.Init()
		'GlowManager.Init()
		'Thrust.Init()
		DataProbe.Generate(55)
		
		BoxedIn.Init()
		GridHit.Init()
		UpRising.Init()
		If Rand(0,100)>70 Then
			Player.TwinEngine=True
		Else
			Player.TwinEngine=False
		End If
		'SeedDifficultyChange=Rnd(0.82,1.15)
		Trash=Rnd(0.82,1.15)
		Water.Init()
		'If this is the very first time starting we'll select a background based on the core seed
		If BackgroundStyle=-1 Or UseSeedStyle
			BackgroundStyle=Rand(1,15)
			SeedBackStore=BackgroundStyle
		Else
			SeedBackStore=Rand(1,15)
		End If
		SeedDifficultyJudge=Abs(100-((SeedDifficultyChange-.82)/.43)*100)
		SeedDifficultyJudge:+(((RandomGain+.08)/.195)*100)*2 'Enemy speed is weighted x2
		SeedDifficultyJudge:/3

		'Print FloatRound(SeedDifficultyJudge,2)
		'Print RandomGain
		'Shot.Generate()
		GameInit(False)
		UpRising.WarmUp()
		GCResume()
		GCCollect()
		'Print "Point 2."+Int(GCMemAlloced()-Malloc)
		
		If SeedDifficultyJudge<=20
			ScoreMultiplier=.125
		Else If SeedDifficultyJudge<=30
			ScoreMultiplier=.25
		Else If SeedDifficultyJudge<=45
			ScoreMultiplier=.5
		Else If SeedDifficultyJudge<=55
			ScoreMultiplier=.75
		Else If SeedDifficultyJudge<=65
			ScoreMultiplier=1.0
		Else If SeedDifficultyJudge<=85
			ScoreMultiplier=1.25
		Else If SeedDifficultyJudge<=95
			ScoreMultiplier=1.5
		Else
			ScoreMultiplier=1.75
		End If
		
		Trk_Mul = SeedJumble(String(ScoreMultiplier),False,False)
		
		If SeedTest="RIQO>SFLIBK@B"
			RandomGain=.42
			PlaySoundBetter Sound_Ultra,ScreenWidth/2,ScreenHeight/2,False,False
			SeedDifficultyJudge=666.00
		End If
		
		If SeedTest="EROQJBMIBKQV"
			RandomGain=.34
			PlaySoundBetter Sound_Ultra,ScreenWidth/2,ScreenHeight/2,False,False
			SeedDifficultyJudge=101.00
		End If
		
		If SeedTest="@LJJ>KABOHBBK" Or SeedTest="HBBK1B"
			PlaySoundBetter Sound_Keen,ScreenWidth/2,ScreenHeight/2,False,False
			Keen4E=True
		End If
		
		If SeedTest="@>Q@E//"
			PlayerName="YOSSARIAN LIVES"
		End If
		If SeedTest="P>IFKDBO"
			PlayerName="HOLDEN CAULFIELD"
		End If
		
		If SeedTest=">MMIBFF" Or SeedTest="@LJJLALOBPRMBOMBQ" Or SeedTest=">MMIBFFB" Or SeedTest="@LJJLALOBMBQ" Or SeedTest="EB>QEHFQE56" Or SeedTest="PFOFRP." Or SeedTest="SF@QLO6---"
			EasterEgg=True
			BackgroundStyle=3
			GlowQuality=256
			ReInitGraphics=True
			'InitGraphics()
		ElseIf SeedTest.Contains("?I>@H") And SeedTest.Contains("TEFQB")
			EasterEgg=2
		ElseIf SeedTest.Contains("PEFOL") And SeedTest.Contains("HROL")
			EasterEgg=2
		ElseIf SeedTest.Contains("KLFO") And SeedTest.Contains("?I>K@")
			EasterEgg=2
		ElseIf SeedTest = "LIAP@ELLI"
			BackgroundStyle=6
			Player.TwinEngine=False
			EasterEgg=0
		Else
			EasterEgg=0
		End If
		
	End If
	
	
End Function


' ---------------------------------------------------


