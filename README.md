[【开发板评测】Renesas RA6M4开发板之ADC、GPIO](https://club.rt-thread.org/ask/article/d6a61a2d915859b0.html "【开发板评测】Renesas RA6M4开发板之ADC、GPIO")
@[toc](【Renesas RA6M4开发板之Arduino六路ADC采样】)

# 1.0 ADC简介
ADC(Analog-to-Digital Converter) 指模数转换器。是指将连续变化的模拟信号转换为离散的数字信号的器件。真实世界的模拟信号，例如温度、压力、声音或者图像等，需要转换成更容易储存、处理和发射的数字形式。模数转换器可以实现这个功能，在各种不同的产品中都可以找到它的身影。与之相对应的 DAC(Digital-to-Analog Converter)，它是 ADC 模数转换的逆向过程。ADC 最早用于对无线信号向数字信号转换。如电视信号，长短播电台发射接收等。

## 1.1 I/O 设备模型框架
如下图所示模数转换一般要经过采样、保持和量化、编码这几个步骤。在实际电路中，有些过程是合并进行的，如采样和保持，量化和编码在转换过程中是同时实现的。
![在这里插入图片描述](https://img-blog.csdnimg.cn/83a09ce9674e4371b5073945e86b5b19.png)

## 1.2 访问 ADC 设备
应用程序通过 RT-Thread 提供的 ADC 设备管理接口来访问 ADC 硬件，相关接口如下所示：
|函数	|描述|
|---|---|
|[rt_device_find()](https://www.rt-thread.org/document/site/#/rt-thread-version/rt-thread-standard/programming-manual/device/adc/adc?id=%E6%9F%A5%E6%89%BE-adc-%E8%AE%BE%E5%A4%87)	|根据 ADC 设备名称查找设备获取设备句柄|
|[rt_adc_enable()](https://www.rt-thread.org/document/site/#/rt-thread-version/rt-thread-standard/programming-manual/device/adc/adc?id=%E4%BD%BF%E8%83%BD-adc-%E9%80%9A%E9%81%93)	|使能 ADC 设备|
|[rt_adc_read()](https://www.rt-thread.org/document/site/#/rt-thread-version/rt-thread-standard/programming-manual/device/adc/adc?id=%E8%AF%BB%E5%8F%96-adc-%E9%80%9A%E9%81%93%E9%87%87%E6%A0%B7%E5%80%BC)	|读取 ADC 设备数据|
|[rt_adc_disable()](https://www.rt-thread.org/document/site/#/rt-thread-version/rt-thread-standard/programming-manual/device/adc/adc?id=%E5%85%B3%E9%97%AD-adc-%E9%80%9A%E9%81%93)	|关闭 ADC 设备|


# 2. RT-theard配置
## 2.1 硬件需求
> 实现功能：
> 板载Arduino拓展口六处模拟信号读取。

1、RA6M4开发板
![在这里插入图片描述](https://img-blog.csdnimg.cn/4c5dcda23c6d4afaacb393dc46a7ae51.png)
2、USB下载线，ch340串口和附带2根母母线，**rx---p613;tx---p614**
![在这里插入图片描述](https://img-blog.csdnimg.cn/26c2a7b5ad914d9a8cf05d4f6de6d78b.png)

*实验中J13六处模拟信号需要焊接插针,方便调试*


## 2.2 软件配置
Renesas RA6M4开发板环境配置参照：[【基于 RT-Thread Studio的CPK-RA6M4 开发板环境搭建】](https://blog.csdn.net/vor234/article/details/125634313)
1、新建项目RA6M4-ADC工程
![在这里插入图片描述](https://img-blog.csdnimg.cn/2f22e0306ce64457ba0d575712467b2d.png)
2、在RT-theard Setting 硬件下开启ADC，使能ADC0
![在这里插入图片描述](https://img-blog.csdnimg.cn/526c090b37ed438286cdf48fd6b9c177.png)
3、打开RA Smart Congigurator，在Stacks中New Stack添加r_adc
![在这里插入图片描述](https://img-blog.csdnimg.cn/bda1a50979544c2586e2397c52669dc3.png)
4、在Property的Module的Channel中勾选Channel0~5
![在这里插入图片描述](https://img-blog.csdnimg.cn/fdd925c84bfa44f7a2c76eb110f06f18.png)5、确认端口一一对应P000~P005
![在这里插入图片描述](https://img-blog.csdnimg.cn/380c26b6c7074e568153db3120e12277.png)
6、然后Generate Project Content 同步更新刚刚配置的文件
![在这里插入图片描述](https://img-blog.csdnimg.cn/668c7e48cd7c41acbd8f968bae9c7c8c.png)
图形化配置已经完成，接下来配置相关代码
# 3. 代码分析
在src文件下新建test_adc.c和test_adc.h文件，其他不变。
![在这里插入图片描述](https://img-blog.csdnimg.cn/7028b8dfcb114b1a96d92078bd48c0b4.png)

`test_adc.c`
```cpp
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

```
`test_adc.h`

```cpp
/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2022-07-11     Asus       the first version
 */
#ifndef TEST_ADC_H_
#define TEST_ADC_H_

static int adc_sample(int argc, char *argv[]);

#endif /* TEST_ADC_H_ */

```
**保存完是灰色，没有保存是蓝色。**
`adc_sample`导 出 到 msh 命 令 列 表 中，采样1次


# 4. 下载验证
1、编译重构
![在这里插入图片描述](https://img-blog.csdnimg.cn/c84c871db3ea4bef8ccede0010528d19.png)
编译成功

2、下载程序
![在这里插入图片描述](https://img-blog.csdnimg.cn/329baeb81df2401f81ab7de738ea87b9.png)

下载成功


3、CMD串口调试

![在这里插入图片描述](https://img-blog.csdnimg.cn/181227ee2ed64ef2801477ece50cf41c.png)
然后板载复位，输入：`adc_sample`
效果如下
![在这里插入图片描述](https://img-blog.csdnimg.cn/5921440d7e1d46c083e25d2cc7c60b3d.png)


这样我们就可以天马行空啦!
![请添加图片描述](https://img-blog.csdnimg.cn/92099d4d054b4b2cbd39b95719739a90.gif)

参考文献；
[【基于 RT-Thread Studio的CPK-RA6M4 开发板环境搭建】](https://blog.csdn.net/vor234/article/details/125634313)
[【开发板评测】Renesas RA6M4开发板之ADC、GPIO](https://club.rt-thread.org/ask/article/d6a61a2d915859b0.html)
