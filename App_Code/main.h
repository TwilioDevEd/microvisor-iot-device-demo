/**
 *
 * Microvisor IoT Device Demo
 * Version 1.0.0
 * Copyright © 2022, Twilio
 * Licence: Apache 2.0
 *
 */
#ifndef _MAIN_H_
#define _MAIN_H_


/*
 * INCLUDES
 */
#include <string.h>
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <errno.h>

#include "stm32u5xx_hal.h"
#include "cmsis_os.h"
#include "mv_syscalls.h"

#include "logging.h"
#include "ht16k33.h"
#include "i2c.h"
#include "mcp9808.h"


#ifdef __cplusplus
extern "C" {
#endif


/*
 * CONSTANTS
 */
#define     LED_GPIO_BANK           GPIOA
#define     LED_GPIO_PIN            GPIO_PIN_5
#define     LED_FLASH_PERIOD        1000

#define     BUTTON_GPIO_BANK        GPIOF
#define     BUTTON_GPIO_PIN         GPIO_PIN_6

#define     DEBUG_TASK_PAUSE        1000
#define     DEFAULT_TASK_PAUSE      500

#define     DEBOUNCE_PERIOD         20


/*
 * PROTOTYPES
 */
void        system_clock_config(void);
void        error_handler(void);
void        start_led_task(void *argument);
void        start_iot_task(void *argument);

void        GPIO_init(void);

void        http_open_channel(void);
void        http_close_channel(void);
bool        http_send_request();



#ifdef __cplusplus
}
#endif


#endif      // _MAIN_H_
