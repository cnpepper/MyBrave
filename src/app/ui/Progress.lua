--血条控件
local Progress = class("Progress",function(background, fill)
	local progress = display.newSprite(background)
	local fill = display.newProgressTimer(fill,display.PROGRESS_TIMER_BAR)
	
	fill:setMidpoint(cc.p(0, 0.5))
	fill:setBarChangeRate(cc.p(1.0, 0))
	fill:setPosition(progress:getContentSize().width/2, progress:getContentSize().height/2)
	progress:addChild(fill)
	fill:setPercentage(100)
	
	return progress
end)

--构造
function Progress:ctor()
end

function Progress:setProgress(progress)
	self.fill:setPercentage(progress)
end

return Progress