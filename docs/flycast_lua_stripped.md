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

void flycast.emulator.startGame(void);
void flycast.emulator.stopGame(void);
void flycast.emulator.pause(void);
void flycast.emulator.resume(void);
void flycast.emulator.saveState(int index);
void flycast.emulator.loadState(int index);
void flycast.emulator.exit(void);

[Top](#table-of-contents)

## flycast.config

### flycast.config.general

int flycast.config.general.Cable;
int flycast.config.general.Region;
int flycast.config.general.Broadcast;
int flycast.config.general.Language;
bool flycast.config.general.AutoLoadState;
bool flycast.config.general.AutoSaveState;
int flycast.config.general.SavestateSlot;
bool flycast.config.general.HideLegacyNaomiRoms;

[Top](#table-of-contents)

### flycast.config.video

bool flycast.config.video.Widescreen;
bool flycast.config.video.SuperWidescreen;
bool flycast.config.video.UseMipmaps;
bool flycast.config.video.ShowFPS;
bool flycast.config.video.RenderToTextureBuffer;
bool flycast.config.video.TranslucentPolygonDepthMask;
bool flycast.config.video.ModifierVolumes;
int flycast.config.video.TextureUpscale;
int flycast.config.video.MaxFilteredTextureSize;
float flycast.config.video.ExtraDepthScale;
bool flycast.config.video.CustomTextures;
bool flycast.config.video.DumpTextures;
int flycast.config.video.ScreenStretching;
bool flycast.config.video.Fog;
bool flycast.config.video.FloatVMUs;
bool flycast.config.video.Rotate90;
bool flycast.config.video.PerStripSorting;
bool flycast.config.video.DelayFrameSwapping;
bool flycast.config.video.WidescreenGameHacks;
int flycast.config.video.SkipFrame;
int flycast.config.video.MaxThreads;
int flycast.config.video.AutoSkipFrame;
int flycast.config.video.RenderResolution;
bool flycast.config.video.VSync;
long flycast.config.video.PixelBufferSize;
int flycast.config.video.AnisotropicFiltering;
int flycast.config.video.TextureFiltering;
bool flycast.config.video.ThreadedRendering;

[Top](#table-of-contents)

### flycast.config.audio

bool flycast.config.audio.DSPEnabled;
int flycast.config.audio.AudioBufferSize;
bool flycast.config.audio.AutoLatency;
std::string flycast.config.audio.AudioBackend;
int flycast.config.audio.AudioVolume;

[Top](#table-of-contents)

### flycast.config.advanced

bool flycast.config.advanced.DynarecEnabled;
bool flycast.config.advanced.SerialConsole;
bool flycast.config.advanced.SerialPTY;
bool flycast.config.advanced.UseReios;
bool flycast.config.advanced.FastGDRomLoad;
bool flycast.config.advanced.OpenGlChecks;

[Top](#table-of-contents)

### flycast.config.network

bool flycast.config.network.NetworkEnable;
bool flycast.config.network.ActAsServer;
std::string flycast.config.network.DNS;
std::string flycast.config.network.NetworkServer;
bool flycast.config.network.EmulateBBA;
bool flycast.config.network.GGPOEnable;
int flycast.config.network.GGPODelay;
bool flycast.config.network.NetworkStats;
int flycast.config.network.GGPOAnalogAxes;

[Top](#table-of-contents)

### flycast.config.maple

int flycast.config.maple.getDeviceType(int bus);
int flycast.config.maple.getSubDeviceType(int bus, int port);
void flycast.config.maple.setDeviceType(int bus, int type);
void flycast.config.maple.setSubDeviceType(int bus, int port, int type);

[Top](#table-of-contents)

## flycast.memory

int flycast.memory.read8(int address);
int flycast.memory.read16(int address);
int flycast.memory.read32(int address);
int flycast.memory.read64(int address);
table<int address, int value> flycast.memory.readTable8(int address, int count);
table<int address, int value> flycast.memory.readTable16(int address, int count);
table<int address, int value> flycast.memory.readTable32(int address, int count);
table<int address, int value> flycast.memory.readTable64(int address, int count);
void flycast.memory.write8(int address, int data);
void flycast.memory.write16(int address, int data);
void flycast.memory.write32(int address, int data);
void flycast.memory.write64(int address, int data);

[Top](#table-of-contents)


## flycast.input 

int    flycast.input.getButtons(int player);
void   flycast.input.pressButtons(int player, int buttons);
void   flycast.input.releaseButtons(int player, int buttons);
int    flycast.input.getAxis(int player, int axis);
void   flycast.input.setAxis(int player, int axis, int value);
int[2] flycast.input.getAbsCoordinates(int player);
void   flycast.input.setAbsCoordinates(int player, int x, int y);
int[2] flycast.input.getRelCoordinates(int player);
void   flycast.input.setRelCoordinates(int player, float x, float y);

[Top](#table-of-contents)

## flycast.state 

int         flycast.state.system;
std::string flycast.state.media;
std::string flycast.state.gameId;

[Top](#table-of-contents)

## flycast.state.display

int flycast.state.display.width;
int flycast.state.display.height;

[Top](#table-of-contents)

## flycast.ui

void flycast.ui.beginWindow(const char * title, int x, int y, int w, int h);
void flycast.ui.endWindow(void);
void flycast.ui.text(const std::string& text);
void flycast.ui.rightText(const std::string& text);
void flycast.ui.bargraph(float v);
void flycast.ui.button(const std::string& label, std::function<void()>);

[Top](#table-of-contents)

## flycast_callbacks

std::function<void()> start;
std::function<void()> pause;
std::function<void()> resume;
std::function<void()> terminate;
std::function<void()> loadState;
std::function<void()> vblank;
std::function<void()> overlay;
flycast_callbacks = {
"start" = cbStart,
"pause" = cbPause,
"resume" = cbResume,
"terminate" = cbTerminate,
"loadState" = cbLoadState,
"vblank" = cbVBlank,
"overlay" = cbOverlay
}

[Top](#table-of-contents)
