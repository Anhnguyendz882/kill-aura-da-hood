--[[ 
    DA HOOD GALAXY V37 - ELITE PREMIUM
    - UI: Kavo UI (Classic Menu)
    - Anti-Ban: Metatable Hooking + Event Spoofing
    - Speed Fix: Vector Velocity (Bypass Da Hood Anti-Speed)
    - Combat: Silent Aimlock + Wallbang Kill Aura (No Delay)
]]

-- 1. KÍCH HOẠT HỆ THỐNG PHÒNG THỦ (ANTI-BAN)
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall
local oldIndex = gmt.__index

gmt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" and self.Name == "MainEvent" then
        -- Chặn đứng mọi báo cáo "lạ" gửi về Server
        if args[1] == "CheckForCheat" or args[1] == "BanMe" or args[1] == "TeleportDetect" or args[1] == "WS" then
            return nil 
        end
    end
    return oldNamecall(self, ...)
end)

gmt.__index = newcclosure(function(self, b)
    if not checkcaller() and self:IsA("Humanoid") then
        if b == "WalkSpeed" then return 16 end
        if b == "JumpPower" then return 50 end
    end
    return oldIndex(self, b)
end)
setreadonly(gmt, true)

-- 2. KHỞI TẠO UI (KAVO)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library:CreateWindow("GALAXY V37 - ELITE", "Grape")

-- BIẾN LOGIC CHUYÊN NGHIỆP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local MainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")

local Settings = {
    KillAura = false,
    AuraRange = 100,
    Speed = 16,
    Jump = 50,
    Aimlock = false,
    Noclip = false,
    AutoEscape = true,
    SafeZone = CFrame.new(-396, 21, -298) -- Tọa độ khu vực an toàn trên mặt đất
}

-- HÀM LẤY MỤC TIÊU GẦN NHẤT (SMART TARGET)
local function GetClosest()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d target = p end
        end
    end
    return target
end

-- TAB CHIẾN ĐẤU (PREMIUM COMBAT)
local Combat = Window:NewTab("Chiến Đấu")
local CombatSec = Combat:NewSection("VIP Combat System")

CombatSec:NewToggle("Kill Aura (Wallbang)", "Bắn xuyên tường cực mạnh", function(v) Settings.KillAura = v end)
CombatSec:NewToggle("Aimlock (Lock Tâm)", "Tự động hướng Camera vào đầu địch", function(v) Settings.Aimlock = v end)
CombatSec:NewSlider("Tầm Aura", "Range", 300, 50, function(v) Settings.AuraRange = v end)

CombatSec:NewButton("TROLL: Void Teleport", "Dìm địch xuống đáy Map", function()
    local t = GetClosest()
    if t then
        local old = LocalPlayer.Character.HumanoidRootPart.CFrame
        for i = 1, 20 do
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1200, 0)
            t.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            task.wait(0.01)
        end
        LocalPlayer.Character.HumanoidRootPart.CFrame = old
    end
end)

-- TAB DI CHUYỂN (BYPASS MOVEMENT)
local Move = Window:NewTab("Di Chuyển")
local MoveSec = Move:NewSection("Elite Movement")

MoveSec:NewSlider("Speed Boost", "Vượt mặt Anti-Cheat", 250, 16, function(v) Settings.Speed = v end)
MoveSec:NewSlider("Jump Height", "Nhảy cao", 300, 50, function(v) Settings.Jump = v end)
MoveSec:NewToggle("Noclip (Xuyên tường)", "Đi xuyên mọi vật cản", function(v) Settings.Noclip = v end)

-- TAB HỆ THỐNG
local Sys = Window:NewTab("Hệ Thống")
local SysSec = Sys:NewSection("Protection & Visuals")

SysSec:NewToggle("Auto Escape (Máu yếu)", "Tự về Safe Zone khi máu < 25", function(v) Settings.AutoEscape = v end)
SysSec:NewButton("FPS Boost (Giảm Lag)", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") then v.Material = "SmoothPlastic" v.CastShadow = false end
    end
end)
SysSec:NewButton("Hiện ESP Highlight", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("Highlight") then
            Instance.new("Highlight", p.Character)
        end
    end
end)

-- 3. CORE LOGIC (VÒNG LẶP XỬ LÝ CHUYÊN NGHIỆP)
RunService.Stepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end

    -- FIX SPEED: Sử dụng Velocity để không bị giật lùi (Bypass chuẩn)
    if Settings.Speed > 16 then
        Char.HumanoidRootPart.Velocity = Char.Humanoid.MoveDirection * Settings.Speed + Vector3.new(0, Char.HumanoidRootPart.Velocity.Y, 0)
    end
    Char.Humanoid.JumpPower = Settings.Jump

    -- NOCLIP
    if Settings.Noclip then
        for _, v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- AUTO ESCAPE: Dịch chuyển về Safe Zone (Shop súng/Bank)
    if Settings.AutoEscape and Char.Humanoid.Health > 0 and Char.Humanoid.Health < 25 then
        Char.HumanoidRootPart.CFrame = Settings.SafeZone
        task.wait(1.5)
    end

    -- KILL AURA ELITE: Fix Dame + Wallbang
    if Settings.KillAura and Char:FindFirstChildOfClass("Tool") then
        local t = GetClosest()
        if t and (Char.HumanoidRootPart.Position - t.Character.HumanoidRootPart.Position).Magnitude <= Settings.AuraRange then
            MainEvent:FireServer("UpdateMousePos", t.Character.Head.Position)
            MainEvent:FireServer("Shoot", t.Character.Head.Position)
        end
    end
end)

-- AIMLOCK: KHÓA CAMERA
RunService.RenderStepped:Connect(function()
    if Settings.Aimlock then
        local t = GetClosest()
        if t and t.Character:FindFirstChild("Head") then
            local Cam = workspace.CurrentCamera
            Cam.CFrame = CFrame.new(Cam.CFrame.Position, t.Character.Head.Position)
        end
    end
end)

print("GALAXY SUPREME V37 - PREMIUM STEALTH READY")
