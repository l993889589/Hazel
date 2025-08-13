#pragma once


#include <csignal>
#include "Core.h"
#include "spdlog/spdlog.h"
#include "spdlog/fmt/ostr.h"

namespace Hazel {

	class HAZEL_API Log
	{
	public:
		static void Init();

		inline static std::shared_ptr<spdlog::logger>& GetCoreLogger() { return s_CoreLogger; }
		inline static std::shared_ptr<spdlog::logger>& GetClientLogger() { return s_ClientLogger; }
	private:
		static std::shared_ptr<spdlog::logger> s_CoreLogger;
		static std::shared_ptr<spdlog::logger> s_ClientLogger;
	};

}


#if defined(_MSC_VER)
#define HZ_DEBUGBREAK() __debugbreak()
#elif defined(__clang__) || defined(__GNUC__)
#define HZ_DEBUGBREAK() __builtin_trap()
#else
#define HZ_DEBUGBREAK() raise(SIGTRAP)
#endif


#ifdef HZ_ENABLE_ASSERTS
// x      : 要断言的条件
// __VA_ARGS__ : 失败时的格式化日志参数
#define HZ_CORE_ASSERT(x, ...)                                                    \
    do {                                                                             \
      if (!(x)) {                                                                    \
        ::Hazel::Log::GetCoreLogger()->error("Assertion Failed: {0}", __VA_ARGS__);  \
        HZ_DEBUGBREAK();                                                             \
      }                                                                              \
    } while (0)
#else
#define HZ_CORE_ASSERT(x, ...)
#endif


// Core log macros
#define HZ_CORE_TRACE(...)    ::Hazel::Log::GetCoreLogger()->trace(__VA_ARGS__)
#define HZ_CORE_INFO(...)     ::Hazel::Log::GetCoreLogger()->info(__VA_ARGS__)
#define HZ_CORE_WARN(...)     ::Hazel::Log::GetCoreLogger()->warn(__VA_ARGS__)
#define HZ_CORE_ERROR(...)    ::Hazel::Log::GetCoreLogger()->error(__VA_ARGS__)
#define HZ_CORE_FATAL(...)    ::Hazel::Log::GetCoreLogger()->fatal(__VA_ARGS__)


// Client log macros
#define HZ_TRACE(...)	      ::Hazel::Log::GetClientLogger()->trace(__VA_ARGS__)
#define HZ_INFO(...)	      ::Hazel::Log::GetClientLogger()->info(__VA_ARGS__)
#define HZ_WARN(...)	      ::Hazel::Log::GetClientLogger()->warn(__VA_ARGS__)
#define HZ_ERROR(...)	      ::Hazel::Log::GetClientLogger()->error(__VA_ARGS__)
#define HZ_FATAL(...)	      ::Hazel::Log::GetClientLogger()->fatal(__VA_ARGS__)