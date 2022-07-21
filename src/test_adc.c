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
#define ADC_NAME        "adc0"  /* ADC �� �� �� �� */
#define ADC_CHANNEL       6     /* ADC ͨ ������ */
#define REFER_VOLTAGE    330    /* �� �� �� ѹ 3.3V,�� �� �� �� �� ��100�� ��2λ С ��
*/
#define CONVERT_BITS (1 << 12) /* ת �� λ �� Ϊ12λ */
static int adc_sample(int argc, char *argv[])
{
    rt_adc_device_t adc_dev;
    rt_uint32_t value, vol;
    rt_err_t ret = RT_EOK;
    /* �� �� �� �� */
    adc_dev = (rt_adc_device_t)rt_device_find(ADC_NAME);
    if (adc_dev == RT_NULL)
    {
        rt_kprintf("adc sample run failed! can't find %s device!\n", ADC_NAME);
        return RT_ERROR;
    }
    for (int var = 0; var < ADC_CHANNEL; ++var) {
        /* ʹ �� �� �� */
        ret = rt_adc_enable(adc_dev, var);
        /* �� ȡ �� �� ֵ */
        value = rt_adc_read(adc_dev, var);
        rt_kprintf("the value is :%d \n", value);
        /* ת �� Ϊ �� Ӧ �� ѹ ֵ */
        vol = value * REFER_VOLTAGE / CONVERT_BITS;
        rt_kprintf("the voltage is :%d.%02d \n", vol / 100, vol % 100);
        /* �� �� ͨ �� */
        ret = rt_adc_disable(adc_dev, var);
    }
    return ret;
}
/* �� �� �� msh �� �� �� �� �� */
MSH_CMD_EXPORT(adc_sample, adc voltage convert sample);




