@echo off

echo copy file into project file . . .
set readmeCP=f
if not exist .\src\readme.lua if exist README.md (
  echo Readme file copied into project folder
  set readmeCP=t
  copy .\README.md .\src\readme.lua
)
set versionCP=f
if not exist .\src\version.txt if exist packageinfo.json (
  echo version [info] file copied into project folder
  set versionCP=t
  copy .\packageinfo.json .\src\version.txt
)
if not exist out (
  mkdir out
)

echo checking project builder
if exist projectBuilder (
  git -C projectBuilder pull
) else (
  echo download builder from https://github.com/nofairTCM/Package
  git clone --depth 1 https://github.com/nofairTCM/Package projectBuilder
)

projectBuilder\bin\luvit.exe projectBuilder uploadFromProjectInfo --this projectBuilder --project build.project.json --info "packageinfo.json" --cookie %cookie%
projectBuilder\bin\luvit.exe projectBuilder build --this projectBuilder --project build.project.json --output "out/build.rbxmx"

echo cleanup . . .
if %versionCP% equ t (
  echo version file removed from project folder
  del .\src\version.txt
)
if %readmeCP% equ t (
  echo readme file removed from project folder
  del .\src\readme.lua
)