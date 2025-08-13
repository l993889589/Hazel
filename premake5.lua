workspace "Hazel"
    architecture "x64"
    startproject "Sandbox"
    configurations { "Debug", "Release", "Dist" }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- 第三方库头文件路径
IncludeDir = {}
IncludeDir["spdlog"] = "Hazel/vendor/spdlog/include"
IncludeDir["GLFW"]   = "Hazel/vendor/GLFW/include"
IncludeDir["GLAD"]   = "Hazel/vendor/GLAD/include"


-- 新增 ImGui
IncludeDir["ImGui"]  = "Hazel/vendor/imgui"
IncludeDir["ImGuiBackends"]  = "Hazel/vendor/imgui/backends"

group "Dependencies"
    include "Hazel/vendor/GLFW"
    include "Hazel/vendor/GLAD"
    include "Hazel/vendor/imgui"    -- 新增这一行
group ""

------------------------------------------------------------
project "Hazel"
    location "Hazel"
    kind     "SharedLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "Off"

    targetdir ("bin/"     .. outputdir .. "/%{prj.name}")
    objdir    ("bin-int/" .. outputdir .. "/%{prj.name}")

    files {
        "Hazel/vendor/GLAD/src/glad.c",
        "Hazel/src/**.h",
        "Hazel/src/**.cpp"
    }

    -- 1. 按照磁盘目录层级映射到 VS Filter
   vpaths {
      ["Hazel/*"] = { "src/Hazel/*.h", "src/Hazel/*.cpp" },
      ["Hazel/Events/*"] = "src/Hazel/Events/**.*",
      ["Hazel/ImGui/*"] = "src/Hazel/ImGui/**.*",
      ["Hazel/Platform/Windows/*"] = "src/Hazel/Platform/Windows/**.*",
   }
    filter "files:**/vendor/GLAD/src/glad.c"
        language "C"
        flags    { "NoPCH" }
    filter {}

    filter "files:**/vendor/imgui/**.cpp"
    flags { "NoPCH" }
    filter {}


    includedirs {
        "Hazel/src",
        IncludeDir.spdlog,
        IncludeDir.GLFW,
        IncludeDir.GLAD,
        IncludeDir.ImGui            -- 新增 ImGui 头文件路径
    }

    pchheader "hzpch.h"
    pchsource "Hazel/src/hzpch.cpp"

    defines { "HZ_BUILD_DLL", "_UNICODE", "UNICODE" }

    filter "system:windows"
        systemversion "latest"
        defines { 
            "HZ_PLATFORM_WINDOWS", 
            "FMT_HEADER_ONLY", 
            "GLFW_INCLUDE_NONE"
        }
        links {
            "GLFW",
            "GLAD",
            "ImGui",               -- 链接 ImGui 静态库
            "opengl32.lib",
            "legacy_stdio_definitions.lib"
        }
        buildoptions { "/utf-8" }

        postbuildcommands {
            '{MKDIR} "%{cfg.targetdir}/../Sandbox"',
            '{COPYFILE} "%{cfg.buildtarget.abspath}" "%{cfg.targetdir}/../Sandbox/"'
        }
    filter {}

    filter "configurations:Debug"
        defines { "HZ_DEBUG", "HZ_ENABLE_ASSERTS" }
        runtime "Debug"
        symbols "On"
    filter {}

    filter "configurations:Release"
        defines { "HZ_RELEASE" }
        runtime "Release"
        optimize "On"
    filter {}

    filter "configurations:Dist"
        defines { "HZ_DIST" }
        runtime "Release"
        optimize "On"
    filter {}

------------------------------------------------------------
project "Sandbox"
    location "Sandbox"
    kind     "ConsoleApp"
    language "C++"
    cppdialect "C++17"
    staticruntime "Off"

    targetdir ("bin/"     .. outputdir .. "/%{prj.name}")
    objdir    ("bin-int/" .. outputdir .. "/%{prj.name}")

    files {
        "Sandbox/src/**.h",
        "Sandbox/src/**.cpp"
    }

    includedirs {
        "Hazel/src",
        IncludeDir.spdlog,
        IncludeDir.GLFW,
        IncludeDir.GLAD,
        IncludeDir.ImGui            -- 如果 Sandbox 直接包含 ImGui 头，可加上这一行
    }

    defines { "HZ_DYNAMIC_LINK", "_UNICODE", "UNICODE" }

    filter "system:windows"
        systemversion "latest"
        defines { 
            "HZ_PLATFORM_WINDOWS", 
            "GLFW_INCLUDE_NONE"
        }
        buildoptions { "/utf-8" }
    filter {}

    links {
        "Hazel",
        "GLFW",
        "GLAD",
        "opengl32.lib",
        "legacy_stdio_definitions.lib"
    }

    filter "configurations:Debug"
        defines { "HZ_DEBUG", "HZ_ENABLE_ASSERTS" }
        runtime "Debug"
        symbols "On"
    filter {}

    filter "configurations:Release"
        defines { "HZ_RELEASE" }
        runtime "Release"
        optimize "On"
    filter {}

    filter "configurations:Dist"
        defines { "HZ_DIST" }
        runtime "Release"
        optimize "On"
    filter {}
