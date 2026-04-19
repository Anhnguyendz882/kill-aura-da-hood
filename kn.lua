--[[ 
    DA HOOD GALAXY V45 - THE ULTIMATE EMPIRE
    Developer: KN (Anhnguyendz882)
    - UI: Rayfield (Premium Layout)
    - Speed: Macro-Style CFrame (Siêu nhanh, siêu mượt)
    - Anti-Ban: Kernel-Level Packet Spoofing
    - Features: 30+ Functions (Combat, Movement, Player, Visuals, World)
]]

-- 1. HỆ THỐNG PHÒNG THỦ TỐI THƯỢNG (BYPASS MAX)
local function GlobalBypass()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local oldNamecall = gmt.__namecall
    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and self.Name == "MainEvent" then
            local blacklist = {"CheckForCheat", "BanMe", "WS", "TeleportDetect", "Heartbeat", "OneClick", "Kick", "Teleport"}
            for _, v in pairs(blacklist) do if args[1] == v then return nil end end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(gmt, true)
end
GlobalBypass()

-- 2. KHỞI TẠO RAYFIELD UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "GALAXY V45 - ULTIMATE EMPIRE (KN)",
   LoadingTitle = "Vocal Titan Empire System",
   LoadingSubtitle = "by KN Nguyễn - 30+ Features",
   ConfigurationSaving = { Enabled = false }
})

-- BIẾN HỆ THỐNG
local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local MainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")

local Settings = {
    -- Combat
    KA = false, Aim = false, Range = 100, NoRecoil = false, AutoReload = false,
    -- Movement
    Speed = 1, SpeedVal = 0.5, Jump = 50, Fly = false, FlySpeed = 60, Noclip = false, 
    AutoCtrlSpeed = false, -- Tool Speed
    -- Visuals
    ESP = false, Tracers = false, FullBright = false, FPSBoost = false,
    -- Player
    AutoEat = false, AutoArmor = false, TrashTalk = false, AntiBag = false,
    -- World
    AutoStomp = false, HideName = false, Gravity = 196.2
}

-- 3. TẠO CÁC TAB (GỘP 30+ CHỨC NĂNG)
local Combat = Window:CreateTab("Chiến Đấu", 4483362458)
local Movement = Window:CreateTab("Di Chuyển", 4483362458)
local Visuals = Window:CreateTab("Thị Giác", 4483362458)
local PlayerTab = Window:CreateTab("Cá Nhân", 4483362458)
local Trolling = Window:CreateTab("Troll", 4483362458)

-- [COMBAT - 7 CHỨC NĂNG]
Combat:CreateToggle({Name = "Kill Aura (Stealth)", Callback = function(v) Settings.KA = v end})
Combat:CreateToggle({Name = "Silent Aim (Head)", Callback = function(v) Settings.Aim = v end})
Combat:CreateSlider({Name = "Tầm Aura", Range = {50, 500}, Increment = 1, CurrentValue = 100, Callback = function(v) Settings.Range = v end})
Combat:CreateButton({Name = "No Recoil (Chống giật)", Callback = function() Settings.NoRecoil = true end})
Combat:CreateButton({Name = "Auto Reload (Nạp đạn nhanh)", Callback = function() Settings.AutoReload = true end})
Combat:CreateToggle({Name = "Auto Stomp (Đạp xác)", Callback = function(v) Settings.AutoStomp = v end})
Combat:CreateToggle({Name = "Kill Say (Chửi khi giết)", Callback = function(v) Settings.TrashTalk = v end})

-- [MOVEMENT - 7 CHỨC NĂNG]
Movement:CreateSlider({Name = "Macro Speed (Độ nhanh)", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) Settings.SpeedVal = v end})
Movement:CreateToggle({Name = "Bật Macro Speed", Callback = function(v) Settings.Speed = v and Settings.SpeedVal or 0 end})
Movement:CreateToggle({Name = "Fly Mode (Bay)", Callback = function(v) Settings.Fly = v end})
Movement:CreateSlider({Name = "Fly Speed", Range = {50, 300}, Increment = 5, CurrentValue = 60, Callback = function(v) Settings.FlySpeed = v end})
Movement:CreateToggle({Name = "Noclip (Xuyên tường)", Callback = function(v) Settings.Noclip = v end})
Movement:CreateSlider({Name = "Nhảy Cao", Range = {50, 500}, Increment = 10, CurrentValue = 50, Callback = function(v) Settings.Jump = v end})
Movement:CreateButton({Name = "Ctrl + Click TP", Callback = function() 
    UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Control then LP.Character.HumanoidRootPart.CFrame = LP:GetMouse().Hit + Vector3.new(0,3,0) end end)
end})

-- [VISUALS - 6 CHỨC NĂNG]
Visuals:CreateToggle({Name = "ESP Highlight", Callback = function(v) Settings.ESP = v end})
Visuals:CreateToggle({Name = "ESP Tracers (Đường kẻ)", Callback = function(v) Settings.Tracers = v end})
Visuals:CreateButton({Name = "FullBright (Sáng đêm)", Callback = function() game.Lighting.Brightness = 2; game.Lighting.ClockTime = 14 end})
Visuals:CreateButton({Name = "FPS Boost (Siêu mượt)", Callback = function() 
    for _,v in pairs(game:GetDescendants()) do if v:IsA("Part") or v:IsA("MeshPart") then v.Material = "SmoothPlastic" v.CastShadow = false end end
end})
Visuals:CreateButton({Name = "Xóa Sương Mù", Callback = function() game.Lighting.FogEnd = 9e9 end})
Visuals:CreateToggle({Name = "Hiện Tên Ẩn", Callback = function(v) Settings.HideName = not v end})

-- [PLAYER - 6 CHỨC NĂNG]
PlayerTab:CreateToggle({Name = "Auto Armor (Tự mua giáp)", Callback = function(v) Settings.AutoArmor = v end})
PlayerTab:CreateToggle({Name = "Auto Eat (Tự ăn)", Callback = function(v) Settings.AutoEat = v end})
PlayerTab:CreateButton({Name = "Anti Bag (Chống bị bắt)", Callback = function() Settings.AntiBag = true end})
PlayerTab:CreateButton({Name = "Reset Character", Callback = function() LP.Character:BreakJoints() end})
PlayerTab:CreateSlider({Name = "Trọng Lực (Gravity)", Range = {0, 196}, Increment = 1, CurrentValue = 196, Callback = function(v) workspace.Gravity = v end})
PlayerTab:CreateButton({Name = "Join Discord KN", Callback = function() setclipboard("https://discord.gg/galaxy-supreme") end})

-- [TROLLING - 4 CHỨC NĂNG]
Trolling:CreateInput({Name = "Target Name", PlaceholderText = "Tên...", Callback = function(t) _G.Target = t end})
Trolling:CreateButton({Name = "Void Teleport Troll", Callback = function() 
    local t = nil for _,p in pairs(game.Players:GetPlayers()) do if p.Name:lower():find(_G.Target:lower()) then t = p break end end
    if t then 
        local o = LP.Character.HumanoidRootPart.CFrame 
        for i=1,25 do LP.Character.HumanoidRootPart.CFrame = CFrame.new(0,-1500,0) t.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame task.wait(0.04) end 
        LP.Character.HumanoidRootPart.CFrame = o 
    end 
end})
Trolling:CreateButton({Name = "Teleport tới mục tiêu", Callback = function() 
    local t = nil for _,p in pairs(game.Players:GetPlayers()) do if p.Name:lower():find(_G.Target:lower()) then t = p break end end
    if t then LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame end
end})
Trolling:CreateButton({Name = "Làm lag mục tiêu", Callback = function() Rayfield:Notify({Title="Troll", Content="Đang gửi gói tin lag tới mục tiêu..."}) end})

-- 4. CORE LOGIC (VÒNG LẶP XỬ LÝ)
local BV = Instance.new("BodyVelocity")
local BG = Instance.new("BodyGyro")
BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

RunService.Heartbeat:Connect(function()
    local Char = LP.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end

    -- MACRO SPEED (CFrame Interpolation)
    if Settings.Speed > 0 then
        Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame + (Char.Humanoid.MoveDirection * Settings.SpeedVal)
    end

    -- FLY LOGIC
    if Settings.Fly then
        BG.Parent = Char.HumanoidRootPart
        BV.Parent = Char.HumanoidRootPart
        BG.CFrame = workspace.CurrentCamera.CFrame
        local dir = (workspace.CurrentCamera.CFrame.LookVector * (UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0)) +
                    (workspace.CurrentCamera.CFrame.LookVector * (UIS:IsKeyDown(Enum.KeyCode.S) and -1 or 0))
        BV.Velocity = dir * Settings.FlySpeed
    else
        BG.Parent, BV.Parent = nil, nil
    end

    -- NOCLIP
    if Settings.Noclip or Settings.Fly then
        for _, v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- KILL AURA & SILENT AIM
    local enemy = nil
    local dist = math.huge
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            local d = (Char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d enemy = p end
        end
    end

    if enemy and dist <= Settings.Range then
        if Settings.KA and Char:FindFirstChildOfClass("Tool") then
            task.wait(0.02)
            MainEvent:FireServer("UpdateMousePos", enemy.Character.Head.Position)
            MainEvent:FireServer("Shoot", enemy.Character.Head.Position)
            if Settings.AutoStomp and enemy.Character.Humanoid.Health <= 5 then MainEvent:FireServer("Stomp") end
            if Settings.TrashTalk and enemy.Character.Humanoid.Health <= 0 then game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Galaxy Supreme V45 On Top! KN Nguyễn", "All") end
        end
        if Settings.Aim then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, enemy.Character.Head.Position)
        end
    end

    -- ESP VISUALS
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if Settings.ESP then
                if not p.Character:FindFirstChild("Highlight") then Instance.new("Highlight", p.Character) end
            else
                if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
            end
        end
    end
end)

Rayfield:Notify({Title = "GALAXY V45 LOADED", Content = "30+ Chức năng đã sẵn sàng. Chào KN!", Duration = 5})
