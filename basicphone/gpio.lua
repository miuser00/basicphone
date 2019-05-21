--- 模块功能：GPIO
-- @author miuser
-- @license MIT
-- @copyright miuser
-- @beta 2019.05.10

module(...,package.seeall)

require"pins"
require"lcd"
require"ui"
require"call"
require"event"

--[[
重要提醒!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

使用某些GPIO时，必须在脚本中写代码打开GPIO所属的电压域，配置电压输出输入等级，这些GPIO才能正常工作
必须在GPIO使用前(即调用pins.setup前)调用pmd.ldoset(电压等级,电压域类型)
电压等级与对应的电压如下：
0--关闭
1--1.8V
2--1.9V
3--2.0V
4--2.6V
5--2.8V
6--3.0V
7--3.3V
IO配置为输出时，高电平时的输出电压即为配置的电压等级对应的电压
IO配置为输入或者中断时，外设输入的高电平电压必须与配置的电压等级的电压匹配

电压域与控制的GPIO的对应关系如下：
pmd.LDO_VMMC：GPIO8、GPIO9、GPIO10、GPIO11、GPIO12、GPIO13
pmd.LDO_VLCD：GPIO14、GPIO15、GPIO16、GPIO17、GPIO18
pmd.LDO_VCAM：GPIO19、GPIO20、GPIO21、GPIO22、GPIO23、GPIO24
一旦设置了某一个电压域的电压等级，受该电压域控制的所有GPIO的高电平都与设置的电压等级一致

例如：GPIO8输出电平时，要求输出2.8V，则调用pmd.ldoset(5,pmd.LDO_VMMC)
]]
--pmd.ldoset(5,pmd.LDO_VMMC)
--pmd.ldoset(5,pmd.LDO_VLCD)
--pmd.ldoset(5,pmd.LDO_VCAM)

local level = 0
local RedBlinking=false
local GreenBlinking=false

--GPIO1配置为输出，默认输出低电平，可通过setGpio1Fnc(0或者1)设置输出电平
setRedLEDFnc = pins.setup(pio.P0_9,0)
setGreenLEDFnc = pins.setup(pio.P0_28,0)

sys.timerLoopStart(function()
    level = level==0 and 1 or 0
    if (RedBlinking==true) then setRedLEDFnc(level) end
end,1000)

sys.timerLoopStart(function()
    level = level==0 and 1 or 0
    if (GreenBlinking==true) then setGreenLEDFnc(level) end
end,500)


function SetRedLEDBlink(interval)
    if (interval==0) then
        RedBlinking=false
    else
        RedBlinking=true
    end
end

function SetGreenLEDBlink(interval)
    if (interval==0) then
        GreenBlinking=false
    else
        GreenBlinking=true
    end
end

--设置红灯状态，val=0,1 常亮常灭，其他值则闪烁
function SetRedLED(val)
    if ((val==0) or (val==1)) then
        --停止闪烁
        SetRedLEDBlink(0)
        --设置灯光电平
        setRedLEDFnc(val)
    else
        SetRedLEDBlink(val)
    end
end

--设置红灯状态，val=0,1 常亮常灭，其他值则闪烁
function SetGreenLED(val)
    if ((val==0) or (val==1)) then
        --停止闪烁
        SetGreenLEDBlink(0)
        --设置灯光电平
        setGreenLEDFnc(val)
    else
        SetGreenLEDBlink(val)
    end
end


function ButtonRedIntFnc(msg)
    log.info("testGpioSingle.ButtonRedIntFnc",msg,getButtonRedFnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.RedKeypress()
    --下降沿中断
    else
    end
end

function ButtonGreenIntFnc(msg)
    log.info("testGpioSingle.ButtonGreenIntFnc",msg,getButtonGreenFnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
    --下降沿中断
        event.GreenKeypress()
    end
end

function ButtonYellowIntFnc(msg)
    log.info("testGpioSingle.ButtonYellowIntFnc",msg,getButtonYellowFnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
    --下降沿中断
        event.YellowKeypress()
    else
    end
end

--GPIO4配置为中断，可通过getGpioFnc()获取输入电平，产生中断时，自动执行IntFnc函数

function Button0IntFnc(msg)
    log.info("testGpioSingle.Button0IntFnc",msg,getButton0Fnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("0")    
    --下降沿中断
    else
    end
end



function Button1IntFnc(msg)
    log.info("testGpioSingle.Button1IntFnc",msg,getButton1Fnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("1") 
    --下降沿中断
    else
    end
end

function Button2IntFnc(msg)
    log.info("testGpioSingle.Button2IntFnc",msg,getButton2Fnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("2") 
    --下降沿中断
    else
    end
end

function Button3IntFnc(msg)
    log.info("testGpioSingle.Button3IntFnc",msg,getButton3Fnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("3") 
    --下降沿中断
    else
    end
end

function Button4IntFnc(msg)
    log.info("testGpioSingle.Button4IntFnc",msg,getButton4Fnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("4") 
    --下降沿中断
    else
    end
end

function Button5IntFnc(msg)
    log.info("testGpioSingle.Button5IntFnc",msg,getButton5Fnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("5") 
    --下降沿中断
    else
    end
end

function Button6IntFnc(msg)
    log.info("testGpioSingle.Button6IntFnc",msg,getButton6Fnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("6") 
    --下降沿中断
    else
    end
end

function Button7IntFnc(msg)
    log.info("testGpioSingle.Button7IntFnc",msg,getButton7Fnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("7") 
    --下降沿中断
    else
    end
end

function Button8IntFnc(msg)
    log.info("testGpioSingle.Button8IntFnc",msg,getButton8Fnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("8") 
    --下降沿中断
    else
    end
end

function Button9IntFnc(msg)
    log.info("testGpioSingle.Button9IntFnc",msg,getButton9Fnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("9") 
    --下降沿中断
    else
    end
end

function ButtonXingIntFnc(msg)
    log.info("testGpioSingle.ButtonXingIntFnc",msg,getButtonXingFnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("*") 
    --下降沿中断
    else
    end
end

function ButtonJingIntFnc(msg)
    log.info("testGpioSingle.ButtonJingIntFnc",msg,getButtonJingFnc())
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        event.NumberKeypress("#") 
    --下降沿中断
    else
    end
end



--GPIO4配置为中断，可通过getGpio4Fnc()获取输入电平，产生中断时，自动执行gpio4IntFnc函数
getButton1Fnc = pins.setup(pio.P0_15,Button1IntFnc)
getButton2Fnc = pins.setup(pio.P0_16,Button2IntFnc)
getButton3Fnc = pins.setup(pio.P0_17,Button3IntFnc)
getButton4Fnc = pins.setup(pio.P0_18,Button4IntFnc)
getButton5Fnc = pins.setup(pio.P0_14,Button5IntFnc)
getButton6Fnc = pins.setup(pio.P0_29,Button6IntFnc)
getButton7Fnc = pins.setup(pio.P0_31,Button7IntFnc)
getButton8Fnc = pins.setup(pio.P0_30,Button8IntFnc)
getButton9Fnc = pins.setup(pio.P0_12,Button9IntFnc)
getButtonXingFnc = pins.setup(pio.P0_11,ButtonXingIntFnc)
getButton0Fnc = pins.setup(pio.P0_10,Button0IntFnc)
getButtonJingFnc = pins.setup(pio.P0_8,ButtonJingIntFnc)

getButtonRedFnc = pins.setup(pio.P0_3,ButtonRedIntFnc)
getButtonGreenFnc = pins.setup(pio.P0_2,ButtonGreenIntFnc)
getButtonYellowFnc = pins.setup(pio.P0_13,ButtonYellowIntFnc)