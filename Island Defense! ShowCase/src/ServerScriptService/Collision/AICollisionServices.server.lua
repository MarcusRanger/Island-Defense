local collectionService = game:GetService("CollectionService")
local PhysicsService = game:GetService("PhysicsService")
 
local AiGroup = "AiGroup"

PhysicsService:CreateCollisionGroup(AiGroup)

PhysicsService:CollisionGroupSetCollidable(AiGroup, AiGroup, false)