---@meta

---@class Flycast.Emulator
---@field startGame fun(path: string): nil
---@field stopGame fun(): nil
---@field pause fun(): nil
---@field resume fun(): nil This doesn't work.
---@field saveState fun(index: integer): nil
---@field loadState fun(index: integer): nil
---@field exit fun(): nil

---@class Flycast.GeneralConfig
---@field Cable integer
---@field Region integer
---@field Broadcast integer
---@field Language integer
---@field AutoLoadState boolean
---@field AutoSaveState boolean
---@field SavestateSlot integer
---@field HideLegacyNaomiRoms integer

---@class Flycast.VideoConfig
---@field Widescreen boolean
---@field SuperWidescreen boolean
---@field UseMipmaps boolean
---@field ShowFPS boolean
---@field RenderToTextureBuffer boolean
---@field TranslucentPolygonDepthMask boolean
---@field ModifierVolumes boolean
---@field TextureUpscale integer
---@field MaxFilteredTextureSize integer
---@field ExtraDepthScale number
---@field CustomTextures boolean
---@field DumpTextures boolean
---@field ScreenStretching integer
---@field Fog boolean
---@field FloatVMUs boolean
---@field Rotate90 boolean
---@field PerStripSorting boolean
---@field DelayFrameSwapping boolean
---@field WidescreenGameHacks boolean
---@field SkipFrame integer
---@field MaxThreads integer
---@field AutoSkipFrame integer
---@field RenderResolution integer
---@field VSync boolean
---@field PixelBufferSize integer
---@field AnisotropicFiltering integer
---@field TextureFiltering integer
---@field ThreadedRendering boolean

---@class Flycast.AudioConfig
---@field DSPEnabled boolean
---@field AudioBufferSize integer
---@field AutoLatency boolean
---@field AudioBackend string
---@field AudioVolume integer

---@class Flycast.AdvancedConfig
---@field DynarecEnabled boolean
---@field SerialConsole boolean
---@field SerialPTY boolean
---@field UseReios boolean
---@field FastGDRomLoad boolean
---@field OpenGlChecks boolean

---@class Flycast.NetworkConfig
---@field NetworkEnable boolean
---@field ActAsServer boolean
---@field DNS string
---@field NetworkServer string
---@field EmulateBBA boolean
---@field GGPOEnable boolean
---@field GGPODelay integer
---@field NetworkStats boolean
---@field GGPOAnalogAxes integer

---@class Flycast.MapleConfig
---@field getDeviceType fun(bus: integer): integer
---@field getSubDeviceType fun(bus: integer, port: integer): integer
---@field setDeviceType fun(bus: integer, type: integer): nil
---@field setSubDeviceType fun(bus: integer, port: integer, type: integer): nil

---@class Flycast.Config
---@field general Flycast.GeneralConfig
---@field video Flycast.VideoConfig
---@field audio Flycast.AudioConfig
---@field advanced Flycast.AdvancedConfig
---@field network Flycast.NetworkConfig
---@field maple Flycast.MapleConfig

---@class Flycast.Memory
---@field read8 fun(address: integer): integer
---@field read16 fun(address: integer): integer
---@field read32 fun(address: integer): integer
---@field read64 fun(address: integer): integer
---@field readTable8 fun(address: integer, count: integer): table<integer, integer>
---@field readTable16 fun(address: integer, count: integer): table<integer, integer>
---@field readTable32 fun(address: integer, count: integer): table<integer, integer>
---@field readTable64 fun(address: integer, count: integer): table<integer, integer>
---@field write8 fun(address: integer, data: integer): nil
---@field write16 fun(address: integer, data: integer): nil
---@field write32 fun(address: integer, data: integer): nil
---@field write64 fun(address: integer, data: integer): nil

---@class Flycast.Input
---@field getButtons fun(player: integer): integer
---@field pressButtons fun(player: integer, buttons: integer): nil
---@field releaseButtons fun(player: integer, buttons: integer): nil
---@field getAxis fun(player: integer, axis: integer): integer
---@field setAxis fun(player: integer, axis: integer, value: integer): nil
---@field getAbsCoordinates fun(player: integer): integer[]
---@field setAbsCoordinates fun(player: integer, x: number, y: number): nil
---@field getRelCoordinates fun(player: integer): integer[]
---@field setRelCoordinates fun(player: integer, x: number, y: number): nil

---@class Flycast.DisplayState
---@field width integer
---@field height integer

---@class Flycast.State
---@field system integer
---@field media string
---@field gameId string
---@field display Flycast.DisplayState

---@class Flycast.UI
---@field beginWindow fun(title: string, x: integer, y: integer, w: integer, h: integer): nil
---@field endWindow fun(): nil
---@field text fun(text: string): nil
---@field rightText fun(text: string): nil
---@field bargraph fun(v: number): nil
---@field button fun(label: string, callback: fun(): nil): nil

---@class Flycast.Callbacks
---@field start fun(): nil
---@field pause fun(): nil
---@field resume fun(): nil
---@field terminate fun(): nil
---@field loadState fun(): nil
---@field vblank fun(): nil
---@field overlay fun(): nil

---@class Flycast
---@field ui Flycast.UI
---@field state Flycast.State
---@field input Flycast.Input
---@field memory Flycast.Memory
---@field config Flycast.Config
---@field emulator Flycast.Emulator
