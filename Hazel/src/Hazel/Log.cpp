// Log.cpp
#include "hzpch.h"
#include <spdlog/fmt/ostr.h>          // <<< 一定要第一行
#include "Log.h"
#include <spdlog/sinks/stdout_color_sinks.h>

namespace Hazel {

    std::shared_ptr<spdlog::logger> Log::s_CoreLogger;
    std::shared_ptr<spdlog::logger> Log::s_ClientLogger;

    void Log::Init()
    {
        spdlog::set_pattern("%^[%T] %n: %v%$");
        s_CoreLogger = spdlog::stdout_color_mt("HAZEL");
        s_ClientLogger = spdlog::stdout_color_mt("APP");

        s_CoreLogger->set_level(spdlog::level::trace);
        s_ClientLogger->set_level(spdlog::level::trace);
    }

} // namespace Hazel
