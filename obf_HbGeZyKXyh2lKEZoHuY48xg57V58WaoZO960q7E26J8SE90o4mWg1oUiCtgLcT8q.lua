local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Breeze",
    Icon = "wind", -- lucide icon
    Author = "Event Bedwars",

    Size = UDim2.fromOffset(460, 460),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    
  
})

Window:Divider()

local Section = Window:Section({
    Title = "Main",
    Icon = "",
    Opened = true,
})

local Main = Section:Tab({
    Title = "Main",
    Icon = "sword", -- optional
    Locked = false,
})

local Utility = Section:Tab({
    Title = "utility",
    Icon = "tool-case", -- optional
    Locked = false,
})

local Render = Section:Tab({
    Title = "render",
    Icon = "eye", -- optional
    Locked = false,
})


local TaskFlags = {}

function Task(name, func)
    if TaskFlags[name] then return end 
    TaskFlags[name] = true
    task.spawn(function()
        while TaskFlags[name] do
            func()
            task.wait(0.1)
        end
    end)
end

function Stop(name)
    TaskFlags[name] = false
end




local Lp = game.Players.LocalPlayer
local PN = Lp.Name


local Inv = game:GetService("ReplicatedStorage"):WaitForChild("Inventories"):WaitForChild(PN)

local Net = {
    ["SwordHit"] = game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("SwordHit")
    --["ProjectileHit"] = 
}

local function Sword()
    return Inv:WaitForChild("stone_sword") 
end

local function Dist(p1,p2)
    return (p1 - p2).Magnitude
end


do 
    local Table = {
        "Spider",
    }

    for i = 1,1500 do
        table.insert(Table,""..i)
    end

    local Range = 20
    local Enabled = false
    local Mode = "CrystalOre"

    local Aura = Main:Toggle({
    Title = "Aura",
    Desc = "Kill Something near you",
    Icon = "check",
    Type = "Checkbox",
    Value = false, 
    Callback = function(Value) 
        Enabled = Value
        if not Enabled then
            Stop("Aura")
            return
        end
        Task("Aura",function()
           
            if Mode == "Spider" then
                for _, obj in pairs(workspace:GetChildren()) do
                    for _, Name in pairs(Table) do
                    if obj:IsA("Model") and table.find(Table, obj.Name) then
                        
                        local PPos = Lp.Character.HumanoidRootPart.Position
                        local ObjPos = obj.PrimaryPart.Position
                        local Sword = Sword()
                        if Dist(Ppos, ObjPos) <= Range then
                            local args = {
                            {
                                chargedAttack = {
                                    chargeRatio = 0
                                },
                                entityInstance = obj,
                                validate = {
                                selfPosition = {
                                    value = PPos
                                },
                                targetPosition = {
                                    value = ObjPos
                                }
                                },
                                weapon = Sword
                            }
                            }
                            Net["SwordHit"]:FireServer(unpack(args))
                        end
                    
                    end

                    end
                end


            elseif Mode == "CrystalOre" then

                    for _, Ore in pairs(workspace:GetChildren()) do
                  
                    if Ore:IsA("Model") and Ore.Name == "CrystalOre" and Ore.PrimaryPart then

                        local PPos = Lp.Character.HumanoidRootPart.Position
                        local OrePos = Ore.PrimaryPart.Position
                        if Dist(PPos, OrePos) <= Range then
                            local args = {
                            {
                                chargedAttack = {
                                    chargeRatio = 0
                                },
                                entityInstance = Ore,
                                validate = {
                                selfPosition = {
                                    value = PPos
                                },
                                targetPosition = {
                                    value = OrePos
                                }
                                },
                                weapon = Inv:WaitForChild("iron_pickaxe_sword") 
                            }
                            }
                            Net["SwordHit"]:FireServer(unpack(args))
                        end
                    end

                    
                end

            end


            
        end)

    end
    })

    local Dropdown1 = Main:Dropdown({
    Title = "Target",
    Desc = "Aura Target",
    Values = { "CrystalOre", "Spider" },
    Value = "CrystalOre",
    Callback = function(option) 
        Mode = option
    end
    })

    local AuraRange = Tab:Slider({
    Title = "Range (STUD)",
    Desc = "STUD",
    
    Step = 1,
    Value = {
        Min = 20,
        Max = 30,
        Default = 20,
    },
    Callback = function(value)
        Range = value
    end
})

end