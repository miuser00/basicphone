
--必须在这个位置定义PROJECT和VERSION变量
--PROJECT：ascii string类型，可以随便定义，只要不使用,就行
--VERSION：ascii string类型，如果使用Luat物联云平台固件升级的功能，必须按照"X.X.X"定义，X表示1位数字；否则可随便定义
PROJECT = "WatchDog"
VERSION = "1.0.0"

require "sys"
require "net"
require"gpio"
require "ui"
require "call"
require "test"
require "console"
console.setup(1, 115200)



tel=""
incoming_tel=""
message="我发一个短信给你"
speech="朋友们，你们好吗"
--功能可以是下列模式： 1 phone:打电话 2 message：发测试短信测试 3 speech:文本转语音测试
--每按下一次黄色按键，功能顺次切换一回
work_mode="phone" 

--状态可以是下列模式： 1 initalizing 初始化 2 standby 待机 3 calling 通话中 4 busy 正在执行状态转换，不接收任何指令 5 incoming 有电话呼入
work_status="initalizing"

--指示灯设置为关闭状态
gpio.SetRedLED(1)
gpio.SetGreenLED(1)

ui.showMsg("正在初始化...")

gpio.SetRedLED(1000)
--启动系统框架
sys.init(0, 0)
sys.run()





