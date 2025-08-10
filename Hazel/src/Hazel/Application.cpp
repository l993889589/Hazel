#pragma once

#include "hzpch.h"
#include "Application.h"

#include <spdlog/fmt/ostr.h>
#include "Hazel/Log.h"
#include "Hazel/Events/ApplicationEvent.h"



namespace Hazel {

	Application::Application()
	{
	}


	Application::~Application()
	{
	}

    void Application::Run()
    {
        WindowResizeEvent e(1280, 720);

        if (e.IsInCategory(EventCategoryApplication))
        {
            HZ_TRACE(e);     // << ���� std::string��spdlog �ܸ�ʽ��
        }

        if (e.IsInCategory(EventCategoryInput))
        {
            HZ_TRACE(e);
        }

        while (true);
    }


}