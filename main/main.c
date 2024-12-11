#include <stdio.h>
#include <inttypes.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#define LOG_LOCAL_LEVEL ESP_LOG_VERBOSE
#include "esp_log.h"

static const char *TAG = "main";

void app_main(void)
{
	ESP_LOGE(TAG, "START");

	do
	{
		printf("Hello world! Wait 3 sec...\n");
		vTaskDelay(3000 / portTICK_PERIOD_MS);
	} while (1);
}
