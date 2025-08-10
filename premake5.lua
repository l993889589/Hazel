workspace "Hazel"
  architecture "x64"
  startproject "Sandbox"
  platforms    { "x64" }
  configurations { "Debug", "Release", "Dist" }

  outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"


filter "system:windows"
  systemversion "latest"
  cppdialect    "C++17"
  staticruntime "On"
  defines       { "HZ_PLATFORM_WINDOWS", "FMT_HEADER_ONLY" }
filter {}

filter "configurations:Debug"
  defines { "HZ_DEBUG" } symbols "On"
filter {}

-- … 其他全局配置 …

project "Hazel"
  location "Hazel"
  kind     "SharedLib"
  language "C++"
  targetdir ("bin/" .. outputdir .. "/%{prj.name}")
  objdir    ("bin-int/".. outputdir .. "/%{prj.name}")

  pchheader "hzpch.h"
  pchsource "Hazel/src/hzpch.cpp"

  files { "Hazel/src/**.h", "Hazel/src/**.cpp" }

    -- 改动在这里：使用 “Hazel/src” 两级过滤器
  vpaths {
    ["Hazel/src"] = {
      "Hazel/src/**.h",
      "Hazel/src/**.cpp",
    }
  }
  includedirs { "Hazel/src", "Hazel/vendor/spdlog/include" }
  defines { "HZ_BUILD_DLL" }

  filter "system:windows"
    postbuildcommands {
      '{MKDIR} "%{cfg.targetdir}/../Sandbox"',
      '{COPYFILE} "%{cfg.buildtarget.abspath}" "%{cfg.targetdir}/../Sandbox/"'
    }
  filter {}

project "Sandbox"
  location "Sandbox"
  kind     "ConsoleApp"
  language "C++"
  targetdir ("bin/" .. outputdir .. "/%{prj.name}")
  objdir    ("bin-int/".. outputdir .. "/%{prj.name}")

  files { "Sandbox/src/**.h", "Sandbox/src/**.cpp" }
  includedirs { "Hazel/src", "Hazel/vendor/spdlog/include" }
  links       { "Hazel" }
