--导入玩家类
local Player = import("..roles.player")
--导入敌人类
local Enemy1 = import("..roles.Enemy1")

local MainScene = class("MainScene", function()
    --return display.newScene("MainScene")
	return display.newPhysicsScene("MainScene")
end)
function MainScene:ctor()
    --[[cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)]]--
	--添加背景到场景
	local background = display.newSprite("flightBG.jpg", display.cx, display.cy)
	self:addChild(background)
	
	--添加玩家到场景
	self.player = Player.new()
	self.player:setPosition(display.left + self.player:getContentSize().width/2, display.cy)
	self:addChild(self.player)
	
	--添加敌人到场景
	self.enemy = Enemy1.new()
	self.enemy:setPosition(display.right - self.enemy:getContentSize().width/2,display.cy)
	self:addChild(self.enemy)
	
	--添加玩家移动方法
	self:addTouchLayer()
	--[[
	--添加碰撞检测
	local world = PhysicsManager:getInstance()
	self:addChild(world)
 
	-- 启动世界更新
	world:start()
 
	-- 显示物理引擎调试层
	self.worldDebug = world:createDebugNode()
	self:addChild(self.worldDebug)
 
	-- 添加碰撞检测函数
	world:addCollisionScriptListener(handler(self, self.onCollision) ,
    CollisionType.kCollisionTypePlayer, CollisionType.kCollisionTypeEnemy)
	]]--
	self.world = self:getPhysicsWorld()
	self.world:setGravity(cc.p(0,0))
	self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
	-- 绑定玩家
	local playerBody = cc.PhysicsBody:createBox(cc.size(self.player:getContentSize().width*2/5, self.player:getContentSize().height))
	--local playerBody = cc.PhysicsBody:createCircle(50, cc.PhysicsMaterial(50, 0.5, 0.5))
	playerBody:setCollisionBitmask(1)
	playerBody:setCategoryBitmask(1)
	self.player:setPhysicsBody(playerBody)
    playerBody:setMass(100)
	--绑定敌人
	local enemyBody = cc.PhysicsBody:createBox(cc.size(self.enemy:getContentSize().width/4, self.enemy:getContentSize().height))
    --local enemyBody = cc.PhysicsBody:createCircle(50, cc.PhysicsMaterial(50, 0.5, 0.5))
	enemyBody:setCollisionBitmask(1)
	enemyBody:setCategoryBitmask(1)
	self.enemy:setPhysicsBody(enemyBody)
	
	--添加一个按钮到场景，用来控制攻击
	local hattck = display.newSprite("#pause1.png",30,30)
	self:addChild(hattck)
	--给这个按钮添加触摸事件
	hattck:setTouchEnabled(true)
	local function onTouchhattck(eventName, x, y)
        if eventName == "began" then
			print("touch hattck")
			self.player:attack()--打击动作
			
			--self.player:dead()
        end
		
    end
	hattck:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		return onTouchhattck(event.name,event.x,event.y)
	end)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end
--响应触摸的方法
function MainScene:addTouchLayer()
	local function onTouch(eventName, x, y)
        if eventName == "began" then
			self.player:doEvent("clickScreen")
            self.player:walkTo({x=x,y=y},self.player:doEvent("stop"))
        end
		--加入处理状态机的代码
		index = index or 1 --取事件字符串索引
		--local fsmEvents = {"clickScreen", "clickEnemy", "beKilled", "stop"}
		--print(fsmEvents[index])
		--self.player:doEvent(fsmEvents[index])
		
		--index = index + 1
		
    end
 
    self.layerTouch = display.newLayer()
    self.layerTouch:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return onTouch(event.name, event.x, event.y)
    end)
    self.layerTouch:setTouchEnabled(true)
    self.layerTouch:setPosition(cc.p(0,0))
    self.layerTouch:setContentSize(cc.size(display.width, display.height))
    self:addChild(self.layerTouch)
end
-- 处理碰撞检测事件
function MainScene:onCollision(eventType, event)
 
    if eventType == 'begin' then
        self.canAttack = true
        local body1 = event:getBody1()
        local body2 = event:getBody2()
 
        if body1:getCollisionType() == CollisionType.kCollisionTypePlayer and body2 then
            body2.isCanAttack = true
        end
    elseif eventType == 'separate' then
        self.canAttack = false
        local body1 = event:getBody1()
        local body2 = event:getBody2()
 
        if body1:getCollisionType() == CollisionType.kCollisionTypePlayer and body2 then
            body2.isCanAttack = false
        end
    end
end
-- 砍人函数
function MainScene:clickEnemy(enemy)
    if self.canAttack then
        if self.player:getState() ~= "attack" then
            self.player:doEvent("clickEnemy")
            print("enemy:canAttack " .. tostring(enemy:getCanAttack()))
            if enemy:getCanAttack() and enemy:getState() ~= 'hit' then
                enemy:doEvent("beHit", {attack = self.player.attack})
            end
        end
    else
        local x,y = self.player:getPosition()
        self.player:walkTo({x=x, y=y})
        if self.player:getState() ~= 'walk' then
            self.player:doEvent("clickScreen")
        end
    end
end
return MainScene
