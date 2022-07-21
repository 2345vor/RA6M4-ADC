/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2022-07-11     Asus       the first version
 */

#include <rtthread.h>
#include <rtdevice.h>
#define ADC_NAME        "adc0"  /* ADC 设 备 名 称 */
#define ADC_CHANNEL       6     /* ADC 通 道个数 */
#define REFER_VOLTAGE    330    /* 参 考 电 压 3.3V,数 据 精 度 乘 以100保 留2位 小 数
*/
#define CONVERT_BITS (1 << 12) /* 转 换 位 数 为12位 */
static int adc_sample(int argc, char *argv[])
{
    rt_adc_device_t adc_dev;
    rt_uint32_t value, vol;
    rt_err_t ret = RT_EOK;
    /* 查 找 设 备 */
    adc_dev = (rt_adc_device_t)rt_device_find(ADC_NAME);
    if (adc_dev == RT_NULL)
    {
        rt_kprintf("adc sample run failed! can't find %s device!\n", ADC_NAME);
        return RT_ERROR;
    }
    for (int var = 0; var < ADC_CHANNEL; ++var) {
        /* 使 能 设 备 */
        ret = rt_adc_enable(adc_dev, var);
        /* 读 取 采 样 值 */
        value = rt_adc_read(adc_dev, var);
        rt_kprintf("the value is :%d \n", value);
        /* 转 换 为 对 应 电 压 值 */
        vol = value * REFER_VOLTAGE / CONVERT_BITS;
        rt_kprintf("the voltage is :%d.%02d \n", vol / 100, vol % 100);
        /* 关 闭 通 道 */
        ret = rt_adc_disable(adc_dev, var);
    }
    return ret;
}
/* 导 出 到 msh 命 令 列 表 中 */
MSH_CMD_EXPORT(adc_sample, adc voltage convert sample);




