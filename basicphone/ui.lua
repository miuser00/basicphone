--- 模块功能：UI界面
-- @author miuser
-- @module ui.UI
-- @license MIT
-- @copyright muser
-- @beta 2019-05-10 

module(...,package.seeall)

require"uiWin"
require"misc"
require"ntp"
require"common"

function clr()
--清空LCD显示缓冲区
disp.clear()
--刷新LCD显示缓冲区到LCD屏幕上
disp.update()
end

--用图片显示大号的数字号码 输入数字或*、#
function showDialNumber(numtext)
    local numfile=""
    if (numtext== "") then return end
    if (numtext== nil) then return end
    numfile=numtext
    if (numtext=="*") then numfile="xing" end
    if (numtext=="#") then numfile="jing" end
    disp.putimage("/ldata/"..numfile..".bmp",80,18)
end

local function showText(text,line)
    if (line==nil) then
        disp.puttext(common.utf8ToGb2312(text),0,0)
    else
        disp.puttext(common.utf8ToGb2312(text),0,(line-1)*16)
    end
end


function showMsg(msg)
    disp.clear()
    showText(msg)
    disp.update()
end


--显示正在拨打的号码
function showDial(numtxt)
    if (_G.tel~="") then
        disp.clear()
        showText("拨打:".._G.tel)
        --如果输入为空，则清除大号数字位的字母
        if (numtxt==nil) then 
            showDialNumber(99) 
        else
            showDialNumber(numtxt)
        end 
        disp.update()
    else
        disp.clear()
        showText("请拨号码...")
        --清除大号数字位的字母
        showDialNumber(99)
        disp.update()
    end

end

--显示正在拨号
function showDialing()
    disp.clear()
    showText("正在拨打:        ".._G.tel)
    disp.update()
end

--显示正在通话
function showCalling()
    disp.clear()
    showText("正在与:           ".._G.incoming_tel.."   通话中")
    disp.update()
end

--显示有来电
function showIncoming()
    disp.clear()
    showText("来电号码为:        ".._G.incoming_tel)
    disp.update()
end

--显示发送短信测试
function showMessage()
    disp.clear()
    showText("短信号码:       ".._G.tel)
    showText("短信内容:       ".._G.message,3)
    disp.update()
end
--显示语音测试
function showSpeech()
    disp.clear()
    showText("测试语音内容为：")
    showText(_G.speech,2)
    disp.update()
end
--显示收到的短信
function showSMS(text)
    disp.clear()
    showText("收到新的短信")
    log.info("ShowSMS",text)
    disp.puttext(text,0,16)
    disp.update()
end
