--[[ 
    DA HOOD GALAXY V50 - THE FINAL BYPASS
    Developer: KN (Anhnguyendz882)
    - Fix: Speed Anti-Ban (Sử dụng BodyVelocity + Heartbeat Sync)
    - Full: Combat, Movement, Visuals, Troll, Item Speed.
]]

-- 1. SIÊU BYPASS - CHẶN CÁC GÓI TIN QUÉT TỌA ĐỘ
local function UltraBypass()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local oldNamecall = gmt.__namecall
    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and self.Name == "MainEvent" then
            -- Chặn toàn bộ các hàm check nhạy cảm của Da Hood
            local blacklist = {"CheckForCheat", "BanMe", "WS", "TeleportDetect", "Heartbeat", "OneClick", "Heartbeat2"}
            for _, v in pairs(blacklist) do if args[1] == v then return nil end end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(gmt, true)
end
UltraBypass()

-- 2. KHỞI TẠO RAYFIELD UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "GALAXY V50 - FINAL BYPASS (KN)",
   LoadingTitle = "Vocal Titan V50 - iOS Edition",
   ConfigurationSaving = { Enabled = false }
})

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local MainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")

local Settings = {
    KA = false, Aim = false, Range = 85,
    SpeedVal = 80, ToolSpeed = false,
    Fly = false, FlySpeed = 60,
    Noclip = false, ESP = false,
    Target = ""
}

-- 3. TẠO SPEED TOOL (VẬT PHẨM TỰ CHẾ)
local function CreateTool()
    local Tool = Instance.new("Tool")
    Tool.Name = "⚡ [KN] SUPREME SPEED"
    Tool.RequiresHandle = false
    Tool.Parent = LP.Backpack
    Tool.Equipped:Connect(function() Settings.ToolSpeed = true end)
    Tool.Unequipped:Connect(function() Settings.ToolSpeed = false end)
end
CreateTool()

-- 4. GIAO DIỆN (TABS)
local Combat = Window:CreateTab("Chiến Đấu", 4483362458)
local Move = Window:CreateTab("Di Chuyển", 4483362458)
local Visual = Window:CreateTab("Thị Giác", 4483362458)
local Troll = Window:CreateTab("Troll", 4483362458)

Combat:CreateToggle({Name = "Kill Aura (Humanized)", Callback = function(v) Settings.KA = v end})
Combat:CreateToggle({Name = "Silent Aim (Head)", Callback = function(v) Settings.Aim = v end})
Combat:CreateSlider({Name = "Range", Range = {50, 200}, Increment = 1, CurrentValue = 85, Callback = function(v) Settings.Range = v end})

Move:CreateSlider({Name = "Speed Value", Range = {16, 200}, Increment = 1, CurrentValue = 80, Callback = function(v) Settings.SpeedVal = v end})
Move:CreateToggle({Name = "Fly Mode", Callback = function(v) Settings.Fly = v end})
Move:CreateToggle({Name = "Noclip", Callback = function(v) Settings.Noclip = v end})

Visual:CreateToggle({Name = "ESP Highlight", Callback = function(v) Settings.ESP = v end})
Visual:CreateButton({Name = "FPS Boost", Callback = function() 
    for _,v in pairs(game:GetDescendants()) do if v:IsA("Part") then v.Material = "SmoothPlastic" end end
end})

Troll:CreateInput({Name = "Target Name", Callback = function(t) Settings.Target = t end})
Troll:CreateButton({Name = "Void Teleport Troll", Callback = function() 
    local t = nil for _,p in pairs(game.Players:GetPlayers()) do if p.Name:lower():find(Settings.Target:lower()) then t = p break end end
    if t then 
        local o = LP.Character.HumanoidRootPart.CFrame
        for i=1,15 do LP.Character.HumanoidRootPart.CFrame = CFrame.new(0,-1000,0) t.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame task.wait(0.06) end
        LP.Character.HumanoidRootPart.CFrame = o
    end
end})

-- 5. HỆ THỐNG XỬ LÝ TRUNG TÂM (ANTI-BAN CORE)
local BV = Instance.new("BodyVelocity")
BV.MaxForce = Vector3.new(1e5, 0, 1e5) -- Chỉ đẩy trục X và Z để tránh bị server kick vì lơ lửng

RunService.Heartbeat:Connect(function()
    local Char = LP.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end

    -- ANTI-BAN SPEED (BODYVELOCITY)
    if Settings.ToolSpeed and not Settings.Fly then
        BV.Parent = Char.HumanoidRootPart
        BV.Velocity = Char.Humanoid.MoveDirection * Settings.SpeedVal
    else
        BV.Parent = nil
    end

    -- FLY LOGIC
    if Settings.Fly then
        Char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) -- Giữ cho nhân vật không rơi
        Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame + (workspace.CurrentCamera.CFrame.LookVector * Settings.FlySpeed / 50)
    end

    -- NOCLIP
    if Settings.Noclip or Settings.Fly then
        for _, v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- COMBAT (SMART DELAY)
    if Settings.KA and Char:FindFirstChildOfClass("Tool") and Char:FindFirstChildOfClass("Tool").Name ~= "⚡ [KN] SUPREME SPEED" then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") and (Char.HumanoidRootPart.Position - p.Character.Head.Position).Magnitude <= Settings.Range then
                task.wait(0.05) -- Delay an toàn chống ban
                MainEvent:FireServer("UpdateMousePos", p.Character.Head.Position)
                MainEvent:FireServer("Shoot", p.Character.Head.Position)
                break
            end
        end
    end

    -- ESP
    if Settings.ESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LP and p.Character and not p.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", p.Character)
            end
        end
    end
end)

Rayfield:Notify({Title = "GALAXY V50 - SUCCESS", Content = "Đã gộp all chức năng & Fix Ban Speed!", Duration = 5})
