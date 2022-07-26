################################################################################
# 自动生成的文件。不要编辑！
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../libraries/HAL_Drivers/drv_adc.c \
../libraries/HAL_Drivers/drv_common.c \
../libraries/HAL_Drivers/drv_gpio.c \
../libraries/HAL_Drivers/drv_usart_v2.c 

OBJS += \
./libraries/HAL_Drivers/drv_adc.o \
./libraries/HAL_Drivers/drv_common.o \
./libraries/HAL_Drivers/drv_gpio.o \
./libraries/HAL_Drivers/drv_usart_v2.o 

C_DEPS += \
./libraries/HAL_Drivers/drv_adc.d \
./libraries/HAL_Drivers/drv_common.d \
./libraries/HAL_Drivers/drv_gpio.d \
./libraries/HAL_Drivers/drv_usart_v2.d 


# Each subdirectory must supply rules for building sources it contributes
libraries/HAL_Drivers/%.o: ../libraries/HAL_Drivers/%.c
	arm-none-eabi-gcc -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\board\ports" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\board" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\libraries\HAL_Drivers\config" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\libraries\HAL_Drivers" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\ra\arm\CMSIS_5\CMSIS\Core\Include" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\ra\fsp\inc\api" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\ra\fsp\inc\instances" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\ra\fsp\inc" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\ra_cfg\fsp_cfg\bsp" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\ra_cfg\fsp_cfg" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\ra_gen" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rt-thread\components\drivers\include" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rt-thread\components\finsh" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rt-thread\components\libc\compilers\common" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rt-thread\components\libc\compilers\newlib" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rt-thread\components\libc\posix\io\poll" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rt-thread\components\libc\posix\io\stdio" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rt-thread\components\libc\posix\ipc" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rt-thread\include" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rt-thread\libcpu\arm\common" -I"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rt-thread\libcpu\arm\cortex-m4" -include"D:\RT-ThreadStudio\workspace\RA6M4-ADC\rtconfig_preinc.h" -std=gnu11 -mcpu=cortex-m33 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -Dgcc -O0 -gdwarf-2 -g -Wall -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"

