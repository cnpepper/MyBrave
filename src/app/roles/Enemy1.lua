--敌人文件
--导入血条类
local Progress = import("..ui.Progress")

--敌人类
local Enemy1 = class("Enemy1",function()
	return display.newSprite("#enemy1-1-1.png")
end)

function Enemy1:ctor()
	--给敌人增加血量条
	self.progress = Progress.new("#small-enemy-progress-bg.png", "#small-enemy-progress-fill.png")
	local size = self:getContentSize()
	self.progress:setPosition(size.width*2/3, size.height + self.progress:getContentSize().height/2)
	self:addChild(self.progress)
	
	--添加碰撞钢体
	--[[local world = PhysicsManager:getInstance()
	self.body = world:createBoxBody(1, self:getContentSize().width/2, self:getContentSize().height)
	--    self.body:bind(self)
	self.body:setCollisionType(CollisionType.kCollisionTypePlayer)
	self.body:setIsSensor(true)
	
	self:scheduleUpdate();
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function()
		self.body:setPosition(self:getPosition())
	end)]]--

end

return Enemy1