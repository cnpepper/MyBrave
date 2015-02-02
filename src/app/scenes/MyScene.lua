local MyScene = class("MyScene",function()
	return display.newScene("MyScene")
end)

function MyScene:ctor()
	--[[cc.ui.UILabel.new({
			UILabelType = 2,text = "hello,MyScene",size = 20})
		:align(display.CENTER,display.cx,display.cy)
		:addTo(self)]]--
end

function MyScene:onEnter()
end

function MyScene:onExit()
end

return MyScene;