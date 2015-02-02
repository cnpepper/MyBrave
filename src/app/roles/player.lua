--玩家文件
--导入血条类
local Progress = import("..ui.Progress")

--玩家类
local Player = class("Player",function()
	local sprite = display.newSprite("#player1-1-1.png")
	return sprite
end)

function Player:ctor()
	--加载动作
	self:addAnimation()	
	--状态机制
	self.fsm_ = {}
	cc.GameObject.extend(self.fsm_)
		:addComponent("components.behavior.StateMachine")
		:exportMethods()
 
	self.fsm_:setupState({
		-- 初始状态
    initial = "idle",
 
    -- 事件和状态转换
    events = {
        -- t1:clickScreen; t2:clickEnemy; t3:beKilled; t4:stop
        
		{name = "stop", from = {"walk", "attack"}, to = "idle"},
		{name = "clickScreen", from = {"idle", "attack"},to = "walk"},
        {name = "clickEnemy",  from = {"idle", "walk"},  to = "attack"},
        {name = "beKilled", from = {"idle", "walk", "attack"},  to = "dead"},
        
    },
 
    -- 状态转变后的回调
    callbacks = {
        onidle = function () print("idle") end,
        onwalk = function () print("move") end,
        onattack = function () print("attack") end,
        ondead = function () print("dead") end
    },
	})
	
	--给玩家添加血条
	self.progress = Progress.new("#small-enemy-progress-bg.png", "#small-enemy-progress-fill.png")
	local size = self:getContentSize()
	self.progress:setPosition(size.width*2/5, size.height + self.progress:getContentSize().height/6)
	self:addChild(self.progress)
	
	-- 添加碰撞钢体
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
function Player:addAnimation()
--定义两个tabel
	local animationNames = {"walk", "attack", "dead"}
	local animationFrameNum = {4, 4, 4}
	
	for i = 1, #animationNames do
		--新建一个帧
		local frames = display.newFrames("player1-"..i.."-%d.png", 1, animationFrameNum[i])
		--用帧创建一个动画，时间间隔是0.2
		local animation = display.newAnimation(frames, 0.2)
		--将动画插入到AnimationCache中
		display.setAnimationCache("player1-"..animationNames[i],animation);
	end
end	

function Player:walkTo(pos,callback)
	local function moveStop()
		transition.stopTarget(self)
		--回调为空则执行回调
		if callback then
			callback()
		end
	end
	
	local currentPos = cc.p(self:getPositionX(),self:getPositionY())
	local destPos = cc.p(pos.x,pos.y)
	local posDiff = cc.pGetDistance(currentPos,destPos)
	--local seq = transition.sequence({tansition:create(5*posDiff/display.width,CCPoint(pos.x,pos.y)),CCCallFunc:create(moveStop)})
	local seq = transition.sequence({transition.moveTo(self,{x = pos.x, y = pos.y,time = 5*posDiff/display.width}),cc.CallFunc:create(moveStop)})
	transition.playAnimationForever(self,display.getAnimationCache("player1-walk"))
	self:runAction(seq)
end

function Player:attack()
	-- 这里也要添加回调方法，模仿walTo的方式最好
	transition.playAnimationOnce(self,display.getAnimationCache("player1-attack"))
end

function Player:dead()
	transition.playAnimationOnce(self,display.getAnimationCache("player1-dead"))
end

function Player:doEvent(event)
	self.fsm_:doEvent(event)
end
return Player