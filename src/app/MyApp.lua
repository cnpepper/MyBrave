
require("config")
require("cocos.init")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
	--一定要在进入场景之前加载所需要的资源
    display.addSpriteFrames("object.plist","object.png")
	display.addSpriteFrames("ui.plist","ui.png")
	
	self:enterScene("MainScene")
	
end

return MyApp
