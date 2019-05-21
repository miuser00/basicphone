--- 模块功能：通话功能测试.
-- @author miuser
-- @module call
-- @license MIT
-- @copyright miuser
-- @release 2019.05.10

module(...,package.seeall)

require"cc"
require"audio"
require"gpio"
require"event"
require"sms"

function Dial(no)
    log.info("calling "..no)
    cc.dial(no)
end

function Hang()
    cc.hangUp(_G.tel)
end

function PlayDemosound()
    --发送DTMF到对端
    cc.sendDtmf("22433")
    --5秒后播放TTS给对端，底层软件必须支持TTS功能
    sys.timerStart(audio.play,5000,0,"TTSCC",_G.speech,7)
end

function PlayTTS(text)
    audio.play(CALL,"FILE","/ldata/call.mp3",audiocore.VOL5)
    sys.timerStart(audio.play,4000,1,"TTS",text,5)
end

--- “通话已建立”消息处理函数
-- @string num，建立通话的对方号码
-- @return 无
function connected(num)
    log.info("testCall.connected")
    event.Connected(num)
end

--- “通话已结束”消息处理函数
-- @return 无
function disconnected()
    log.info("testCall.disconnected")
    event.Disconnected()
    sys.timerStopAll(cc.hangUp)
end

--- “来电”消息处理函数
-- @string num，来电号码
-- @return 无
function incoming(num)
    --log.info("testCall.incoming:"..num)
    sys.timerStart(event.CallIncoming,1000,num)
    --接听来电
    --cc.accept(num)

end

function Accept(num)
    --接听来电
    cc.accept(num)    
end


--- “通话功能模块准备就绪””消息处理函数
-- @return 无
function ready()
    --log.info("tesCall.ready")
    _G.phone_ready="true"

    event.PhoneReady()
    log.info("Set lineready signal to "..phone_ready)

    --呼叫10086
    --cc.dial(_G.tel)
end

--发送短信完成后的回调
local function smsCallback(result,num,data)
    log.info("testSms",result,num,data)
    event.SMSSent()
end

--发送短信
function SendSMS(num,content)
    sms.send(num,common.utf8ToGb2312(content),smsCallback)
end

--接收短信
local function procnewsms(num,data,datetime)
    log.info("testSms.procnewsms",num,data,datetime)
    event.ReceivedSMS(num,data,datetime)
end

sms.setNewSmsCb(procnewsms)

--- “通话中收到对方的DTMF”消息处理函数
-- @string dtmf，收到的DTMF字符
-- @return 无
local function dtmfDetected(dtmf)
    log.info("testCall.dtmfDetected",dtmf)
end

--订阅消息的用户回调函数
sys.subscribe("CALL_READY",ready)
sys.subscribe("CALL_INCOMING",incoming)
sys.subscribe("CALL_CONNECTED",connected)
sys.subscribe("CALL_DISCONNECTED",disconnected)
cc.dtmfDetect(true)
sys.subscribe("CALL_DTMF_DETECT",dtmfDetected)

