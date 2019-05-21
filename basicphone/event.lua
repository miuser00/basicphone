module(...,package.seeall)

require"gpio"
require "ui"
require "call"
require "test"

function ShowHint(workmode)
    if (workmode=="phone") then ui.showDial() end
    if (workmode=="message") then ui.showMessage() end
    if (workmode=="speech") then ui.showSpeech() end
end

function SetWorkMode(workmode)
    _G.work_mode=workmode
    ui.showMsg("当前工作模式为："..workmode)
    sys.timerStart(ShowHint,1000,workmode)
end

--按下数字号码
function NumberKeypress(num)
    _G.tel=_G.tel..num
    ui.showDial(num)
end

--按下红色按键
function RedKeypress()
    if (_G.work_status=="standby") then
        if (_G.tel~="") then
            _G.tel=string.sub(_G.tel,1,string.len(_G.tel)-1)
        end
        ui.showDial()
    elseif ((_G.work_status=="incoming")or(_G.work_status=="calling")) then
        call.Hang()
        ui.showDial()
    end
end

--按下绿色按键
function GreenKeypress()
    if (_G.work_status=="standby") then
        if (_G.work_mode=="phone") then
            call.Dial(_G.tel)
            ui.showDialing()
            _G.tel=""
        elseif (_G.work_mode=="message") then
            ui.showMsg("正在发送")
            call.SendSMS(_G.tel,_G.message)
        elseif (_G.work_mode=="speech") then
            log.info("播放TTS",_G.speech)
            call.PlayTTS(_G.speech)
        end
    elseif (_G.work_status=="incoming") then
        call.Accept(incoming_tel)
    end
end
  
--按下黄色按键
function YellowKeypress()   
    --每按下一次黄色按键，功能改变一次
    if (_G.work_mode=="phone") then 
        _G.work_mode="message"
    elseif (_G.work_mode=="message") then 
        _G.work_mode="speech"
    elseif (_G.work_mode=="speech") then
        _G.work_mode="phone"
    end
    SetWorkMode(_G.work_mode)
end


--有来电
function CallIncoming(num)
    gpio.SetGreenLED(300)
    _G.incoming_tel=num
    _G.work_status="incoming"
    ui.showIncoming()
    --call.Accept(num)

end

--电话接听
function Connected(num)
    _G.incoming_tel=num
    gpio.SetGreenLED(0)
    _G.work_status="calling"
    ui.showCalling()
    call.PlayDemosound()
end

--电话被挂断
function Disconnected()
    --关闭通话灯
    gpio.SetGreenLED(1)
    _G.work_status="standby"
    ui.showDial()
end

function PhoneReady()
    --红色网络灯点亮
    gpio.SetRedLED(0)
    _G.work_status="standby"
    ui.showDial()
end

function SMSSent()
    ui.showMsg("短信发送完毕")
    sys.timerStart(ShowHint,1000,_G.work_mode)
end

function ReceivedSMS(num,data,datetime)
    ui.showSMS(data)
    sys.timerStart(ShowHint,3000,_G.work_mode)
end