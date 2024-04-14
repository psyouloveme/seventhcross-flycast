# Flycast Lua Reference

Because flycast doesn't have one.

## Table of Contents

1. [flycast.emulator](#flycastemulator)
1. [flycast.config](#flycastconfig)
    1. [flycast.config.general](#flycastconfiggeneral)
    1. [flycast.config.video](#flycastconfigvideo)
    1. [flycast.config.audio](#flycastconfigaudio)
    1. [flycast.config.advanced](#flycastconfigadvanced)
    1. [flycast.config.network](#flycastconfignetwork)
    1. [flycast.config.maple](#flycastconfigmaple)
1. [flycast.memory](#flycastmemory)
1. [flycast.input](#flycastinput)
1. [flycast.state](#flycaststate)
    1. [flycast.state.display](#flycaststatedisplay)
1. [flycast.ui](#flycastui)
1. [flycast_callbacks](#flycast_callbacks)

## flycast.emulator

```c++
void flycast.emulator.startGame(void);
```
```c++
void flycast.emulator.stopGame(void);
```
```c++
void flycast.emulator.pause(void);
```
```c++
void flycast.emulator.resume(void);
```
```c++
void flycast.emulator.saveState(int index);
```
```c++
void flycast.emulator.loadState(int index);
```
```c++
void flycast.emulator.exit(void);
```

[Top](#table-of-contents)

## flycast.config

### flycast.config.general

```c++
int flycast.config.general.Cable;
```
```c++
int flycast.config.general.Region;
```
```c++
int flycast.config.general.Broadcast;
```
```c++
int flycast.config.general.Language;
```
```c++
bool flycast.config.general.AutoLoadState;
```
```c++
bool flycast.config.general.AutoSaveState;
```
```c++
int flycast.config.general.SavestateSlot;
```
```c++
bool flycast.config.general.HideLegacyNaomiRoms;
```

[Top](#table-of-contents)

### flycast.config.video

```c++
bool flycast.config.video.Widescreen;
```
```c++
bool flycast.config.video.SuperWidescreen;
```
```c++
bool flycast.config.video.UseMipmaps;
```
```c++
bool flycast.config.video.ShowFPS;
```
```c++
bool flycast.config.video.RenderToTextureBuffer;
```
```c++
bool flycast.config.video.TranslucentPolygonDepthMask;
```
```c++
bool flycast.config.video.ModifierVolumes;
```
```c++
int flycast.config.video.TextureUpscale;
```
```c++
int flycast.config.video.MaxFilteredTextureSize;
```
```c++
float flycast.config.video.ExtraDepthScale;
```
```c++
bool flycast.config.video.CustomTextures;
```
```c++
bool flycast.config.video.DumpTextures;
```
```c++
int flycast.config.video.ScreenStretching;
```
```c++
bool flycast.config.video.Fog;
```
```c++
bool flycast.config.video.FloatVMUs;
```
```c++
bool flycast.config.video.Rotate90;
```
```c++
bool flycast.config.video.PerStripSorting;
```
```c++
bool flycast.config.video.DelayFrameSwapping;
```
```c++
bool flycast.config.video.WidescreenGameHacks;
```
```c++
int flycast.config.video.SkipFrame;
```
```c++
int flycast.config.video.MaxThreads;
```
```c++
int flycast.config.video.AutoSkipFrame;
```
```c++
int flycast.config.video.RenderResolution;
```
```c++
bool flycast.config.video.VSync;
```
```c++
long flycast.config.video.PixelBufferSize;
```
```c++
int flycast.config.video.AnisotropicFiltering;
```
```c++
int flycast.config.video.TextureFiltering;
```
```c++
bool flycast.config.video.ThreadedRendering;
```

[Top](#table-of-contents)

### flycast.config.audio

```c++
bool flycast.config.audio.DSPEnabled;
```
```c++
int flycast.config.audio.AudioBufferSize;
```
```c++
bool flycast.config.audio.AutoLatency;
```
```c++
std::string flycast.config.audio.AudioBackend;
```
```c++
int flycast.config.audio.AudioVolume;
```

[Top](#table-of-contents)

### flycast.config.advanced

```c++
bool flycast.config.advanced.DynarecEnabled;
```
```c++
bool flycast.config.advanced.SerialConsole;
```
```c++
bool flycast.config.advanced.SerialPTY;
```
```c++
bool flycast.config.advanced.UseReios;
```
```c++
bool flycast.config.advanced.FastGDRomLoad;
```
```c++
bool flycast.config.advanced.OpenGlChecks;
```

[Top](#table-of-contents)

### flycast.config.network

```c++
bool flycast.config.network.NetworkEnable;
```
```c++
bool flycast.config.network.ActAsServer;
```
```c++
std::string flycast.config.network.DNS;
```
```c++
std::string flycast.config.network.NetworkServer;
```
```c++
bool flycast.config.network.EmulateBBA;
```
```c++
bool flycast.config.network.GGPOEnable;
```
```c++
int flycast.config.network.GGPODelay;
```
```c++
bool flycast.config.network.NetworkStats;
```
```c++
int flycast.config.network.GGPOAnalogAxes;
```

[Top](#table-of-contents)

### flycast.config.maple

```c++
int flycast.config.maple.getDeviceType(int bus);
```
```c++
int flycast.config.maple.getSubDeviceType(int bus, int port);
```
```c++
void flycast.config.maple.setDeviceType(int bus, int type);
```
```c++
void flycast.config.maple.setSubDeviceType(int bus, int port, int type);
```

[Top](#table-of-contents)

## flycast.memory

```c++
int flycast.memory.read8(int address);
```
```c++
int flycast.memory.read16(int address);
```
```c++
int flycast.memory.read32(int address);
```
```c++
int flycast.memory.read64(int address);
```
```c++
table<int address, int value> flycast.memory.readTable8(int address, int count);
```
```c++
table<int address, int value> flycast.memory.readTable16(int address, int count);
```
```c++
table<int address, int value> flycast.memory.readTable32(int address, int count);
```
```c++
table<int address, int value> flycast.memory.readTable64(int address, int count);
```
```c++
void flycast.memory.write8(int address, int data);
```
```c++
void flycast.memory.write16(int address, int data);
```
```c++
void flycast.memory.write32(int address, int data);
```
```c++
void flycast.memory.write64(int address, int data);
```

[Top](#table-of-contents)


## flycast.input 

```c++
int flycast.input.getButtons(int player);
```
```c++
void flycast.input.pressButtons(int player, int buttons);
```
```c++
void flycast.input.releaseButtons(int player, int buttons);
```
```c++
int flycast.input.getAxis(int player, int axis);
```
```c++
void flycast.input.setAxis(int player, int axis, int value);
```
```c++
int[2] flycast.input.getAbsCoordinates(int player);
```
```c++
void flycast.input.setAbsCoordinates(int player, int x, int y);
```
```c++
int[2] flycast.input.getRelCoordinates(int player);
```
```c++
void flycast.input.setRelCoordinates(int player, float x, float y);
```

[Top](#table-of-contents)

## flycast.state 

```c++
int flycast.state.system;
```
```c++
std::string flycast.state.media;
```
```c++
std::string flycast.state.gameId;
```

[Top](#table-of-contents)

## flycast.state.display

```c++
int flycast.state.display.width;
```
```c++
int flycast.state.display.height;
```

[Top](#table-of-contents)

## flycast.ui

```c++
void flycast.ui.beginWindow(const char * title, int x, int y, int w, int h);
```
```c++
void flycast.ui.endWindow(void);
```
```c++
void flycast.ui.text(const std::string& text);
```
```c++
void flycast.ui.rightText(const std::string& text);
```
```c++
void flycast.ui.bargraph(float v);
```
```c++
void flycast.ui.button(const std::string& label, std::function<void()>);
```

[Top](#table-of-contents)

## flycast_callbacks

```c++
std::function<void()> start;
```
```c++
std::function<void()> pause;
```
```c++
std::function<void()> resume;
```
```c++
std::function<void()> terminate;
```
```c++
std::function<void()> loadState;
```
```c++
std::function<void()> vblank;
```
```c++
std::function<void()> overlay;
```
```lua
flycast_callbacks = {
"start" = cbStart,
"pause" = cbPause,
"resume" = cbResume,
"terminate" = cbTerminate,
"loadState" = cbLoadState,
"vblank" = cbVBlank,
"overlay" = cbOverlay
}
```

[Top](#table-of-contents)
