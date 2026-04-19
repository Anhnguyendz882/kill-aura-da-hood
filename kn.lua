--[[ 
    DA HOOD GALAXY V42 - GOD MODE EDITION
    Developer: KN (Anhnguyendz882)
    - Fix: Anti-Ban Max (Block Heartbeat & Log)
    - Features: Fly Speed, Kill Aura, Silent Aim, Target Troll, Noclip.
]]

-- 1. SIÊU BYPASS ANTI-BAN (BẢO VỆ TỐI ĐA)
local function Protect()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local oldNamecall = gmt.__namecall
    
    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and self.Name == "MainEvent" then
            -- Chặn các gói tin nhạy cảm dễ gây Ban
            local blacklist = {"CheckForCheat", "BanMe", "WS", "TeleportDetect", "Heartbeat"}
            for _, v in pairs(blacklist) do if args[1] == v then return nil end end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(gmt, true)
end
Protect()

-- 2. KHỞI TẠO RAYFIELD UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "GALAXY V42 - GOD MODE (KN)",
   LoadingTitle = "Vocal Titan Elite System",
   LoadingSubtitle = "by KN Nguyễn",
   ConfigurationSaving = { Enabled = false }
})

-- BIẾN HỆ THỐNG
local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local MainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")
local Settings = {
    KA = false, Aim = false, Speed = 16, Range = 100,
    Noclip = false, Fly = false, FlySpeed = 50, Target = "",
    SafePos = CFrame.new(-396, 21, -298)
}

-- 3. TẠO CÁC TAB CHỨC NĂNG
local Combat = Window:CreateTab("Combat", 4483362458)
local Move = Window:CreateTab("Movement", 4483362458)
local Troll = Window:CreateTab("Trolling", 4483362458)

-- [COMBAT TAB]
Combat:CreateToggle({
   Name = "Kill Aura (Wallbang Headshot)",
   CurrentValue = false,
   Callback = function(v) Settings.KA = v end,
})

Combat:CreateToggle({
   Name = "Silent Aim (Auto Lock Head)",
   CurrentValue = false,
   Callback = function(v) Settings.Aim = v end,
})

Combat:CreateSlider({
   Name = "Aura Range",
   Range = {50, 300},
   Increment = 1,
   CurrentValue = 100,
   Callback = function(v) Settings.Range = v end,
})

-- [MOVEMENT TAB - THÊM FLY SPEED]
Move:CreateToggle({
   Name = "Fly Mode (Bay Tự Do)",
   CurrentValue = false,
   Callback = function(v) Settings.Fly = v end,
})

Move:CreateSlider({
   Name = "Fly Speed (Tốc độ bay)",
   Range = {10, 200},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) Settings.FlySpeed = v end,
})

Move:CreateSlider({
   Name = "Walk Speed (Chạy nhanh)",
   Range = {16, 150},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) Settings.Speed = v end,
})

Move:CreateToggle({
   Name = "Noclip (Xuyên Tường)",
   CurrentValue = false,
   Callback = function(v) Settings.Noclip = v end,
})

-- [TROLLING TAB]
Troll:CreateInput({
   Name = "Tên Nạn Nhân",
   PlaceholderText = "Nhập tên...",
   Callback = function(t) Settings.Target = t end,
})

Troll:CreateButton({
   Name = "Teleport Void Troll",
   Callback = function()
      local target = nil
      for _, p in pairs(game.Players:GetPlayers()) do
         if p.Name:lower():find(Settings.Target:lower()) then target = p break end
      end
      if target and target.Character then
         local oldPos = LP.Character.HumanoidRootPart.CFrame
         LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
         task.wait(0.2)
         for i = 1, 25 do
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1500, 0)
            target.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame
            task.wait(0.04)
         end
         LP.Character.HumanoidRootPart.CFrame = oldPos
      end
   end,
})

-- 4. CORE LOGIC (XỬ LÝ FLY & COMBAT)
local BodyGyro = Instance.new("BodyGyro")
local BodyVelocity = Instance.new("BodyVelocity")
BodyGyro.P = 9e4
BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

RunService.Stepped:Connect(function()
    local Char = LP.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end

    -- FLY LOGIC
    if Settings.Fly then
        BodyGyro.Parent = Char.HumanoidRootPart
        BodyVelocity.Parent = Char.HumanoidRootPart
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        local dir = (workspace.CurrentCamera.CFrame.LookVector * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) and 1 or 0)) +
                    (workspace.CurrentCamera.CFrame.LookVector * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) and -1 or 0)) +
                    (workspace.CurrentCamera.CFrame.RightVector * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) and 1 or 0)) +
                    (workspace.CurrentCamera.CFrame.RightVector * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) and -1 or 0))
        BodyVelocity.Velocity = dir * Settings.FlySpeed
    else
        BodyGyro.Parent = nil
        BodyVelocity.Parent = nil
    end

    -- SPEED BYPASS
    if not Settings.Fly and Settings.Speed > 16 then
        Char.HumanoidRootPart.Velocity = Char.Humanoid.MoveDirection * Settings.Speed + Vector3.new(0, Char.HumanoidRootPart.Velocity.Y, 0)
    end

    -- NOCLIP
    if Settings.Noclip or Settings.Fly then
        for _, v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- KILL AURA & AIMLOCK
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
            MainEvent:FireServer("UpdateMousePos", enemy.Character.Head.Position)
            MainEvent:FireServer("Shoot", enemy.Character.Head.Position)
        end
        if Settings.Aim then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, enemy.Character.Head.Position)
        end
    end
end)

Rayfield:Notify({Title = "GALAXY V42 LOADED", Content = "Chào Khánh, quậy khéo nhé!", Duration = 5})
