# AppLauncher
Launcher and updater for NPL powered apps. This project will generate a single executable file 
without any external dependency, making it easy to self-update and redistribute. 
All NPL scripts, textures and dlls are embedded or linked statically in the executable.

## How to Build (Win32)
The prerequisits are the same as building NPLRuntime Client version which is documented 
in greater details [here](https://github.com/LiXizhi/NPLRuntime/wiki/InstallGuide#install-on-windows-from-source)

First prepare the build by downloading boost 1.64 or above, and build static runtime of boost and add
an environment variable `BOOT_ROOT` that points to the boost folder. 
```
cd boost
bootstrap
b2 runtime-link=static --with-thread --with-date_time --with-filesystem --with-system --with-chrono --with-signals --with-serialization --with-iostreams --with-regex stage
```

Download and install cmake 3.2 or above. 

Finally clone and build with following command. 
```
git clone --recursive https://github.com/tatfook/AppLauncher.git
cd AppLauncher
build_win32.bat
```

## Internals
The build system will first generate a small build tool called `embed-resource`, which can 
transform any binary files into cxx file for embedding in the final executable in a cross-platform
way, such as shader files, NPL packages, etc. 

`npl_packages/AppLauncher` is a pure NPL application for all the UI and functions. 
The build system will automatically zip the folder in to a single npl package zip file, which 
is included in `AppLauncher` by the `embed-resource` tool.

`AppLauncher` is a win32 executable that statically linked to the static lib of NPLRuntime. 
The static lib of NPLRuntime links everything statically without any external dll dependencies. 

So the final result of the build system is a single executable at `./release/AppLauncher.exe`
## Debug
- Embed main package
```
set(MAIN_PACKAGE_EMBEDDED ON)
```
- Do not load remote page
```
append launcher_debug="true" in cmdline
or
using vs Debug configuration to build solution
```
