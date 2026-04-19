--[[ 
    DA HOOD GALAXY V33 - ULTIMATE FINAL EDITION
    Developer: KN (Anhnguyendz882)
    Fix: Menu 100% hiện, Anti-Ban Mạnh, Wallbang, Troll, Noclip, Auto Escape.
]]

-- 1. SIÊU BYPASS ANTI-BAN (CHẠY TRƯỚC TIÊN)
local function UltraBypass()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local oldNamecall = gmt.__namecall
    local oldIndex = gmt.__index

    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        -- Chặn đứng các sự kiện check hack của Da Hood (Adonis & MainEvent)
        if method == "FireServer" and self.Name == "MainEvent" then
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
end
UltraBypass()

-- 2. KHỞI TẠO UI KAVO (KHÔNG LỖI MENU)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library:CreateWindow("GALAXY V33 - KN PRO", "Grape")

-- BIẾN HỆ THỐNG
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local MainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")

local Settings = {
    KillAura = false,
    AuraRange = 90,
    Whitelist = {"KN_Admin", "Anhnguyendz882"},
    WalkSpeed = 16,
    JumpPower = 50,
    ESP = false,
    Noclip = false,
    AutoEscape = true,
    MinHealth = 30
}

-- 3. TẠO CÁC TAB CHỨC NĂNG
local Tab1 = Window:NewTab("Chiến Đấu")
local Sec1 = Tab1:NewSection("Kill Aura VIP & Troll")

Sec1:NewToggle("Bật Kill Aura (Wallbang)", "Bắn xuyên mọi vật cản", function(state)
    Settings.KillAura = state
end)

Sec1:NewSlider("Tầm xa Aura", "Range", 250, 50, function(v)
    Settings.AuraRange = v
end)

Sec1:NewButton("TROLL: Teleport Void", "Dìm mục tiêu xuống vực", function()
    local Target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 30 then
                Target = p break
            end
        end
    end
    if Target then
        local OldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        for i = 1, 20 do
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1500, 0)
            Target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            task.wait(0.01)
        end
        LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
    end
end)

local Tab2 = Window:NewTab("Di Chuyển")
local Sec2 = Tab2:NewSection("Speed, Jump & Noclip")

Sec2:NewToggle("Noclip (Đi xuyên tường)", "Đi xuyên mọi thứ", function(state)
    Settings.Noclip = state
end)

Sec2:NewSlider("Tốc độ", "Speed", 250, 16, function(v)
    Settings.WalkSpeed = v
end)

Sec2:NewSlider("Nhảy cao", "Jump", 300, 50, function(v)
    Settings.JumpPower = v
end)

local Tab3 = Window:NewTab("Hệ Thống")
local Sec3 = Tab3:NewSection("Bảo Vệ & Visuals")

Sec3:NewToggle("Hiện ESP Kẻ Thù", "Soi xuyên tường", function(state)
    Settings.ESP = state
end)

Sec3:NewToggle("Auto Escape (Máu yếu)", "Tự động trốn", function(state)
    Settings.AutoEscape = state
end)

Sec3:NewButton("FPS Boost (Giảm Lag)", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") then v.Material = "SmoothPlastic" v.CastShadow = false end
    end
end)

-- 4. VÒNG LẶP XỬ LÝ CHÍNH (CORE LOGIC)
RunService.Stepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end
    
    -- Noclip Logic
    if Settings.Noclip then
        for _, v in pairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Movement Logic
    Char.Humanoid.WalkSpeed = Settings.WalkSpeed
    Char.Humanoid.JumpPower = Settings.JumpPower

    -- Auto Escape (Teleport trốn khi bị bắn đau)
    if Settings.AutoEscape and Char.Humanoid.Health > 0 and Char.Humanoid.Health < Settings.MinHealth then
        Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame * CFrame.new(0, 1000, 0)
        task.wait(2)
    end

    -- Kill Aura VIP (Wallbang + Fixed Damage)
    if Settings.KillAura and Char:FindFirstChildOfClass("Tool") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local safe = false
                for _, n in pairs(Settings.Whitelist) do if p.Name == n or p.DisplayName == n then safe = true break end end
                
                if not safe and p.Character.Humanoid.Health > 0 then
                    local root = p.Character.HumanoidRootPart
                    if (Char.HumanoidRootPart.Position - root.Position).Magnitude <= Settings.AuraRange then
                        -- Gửi packet chuẩn gây dame xuyên tường
                        MainEvent:FireServer("UpdateMousePos", root.Position)
                        MainEvent:FireServer("Shoot", root.Position)
                    end
                end
            end
        end
    end
end)

-- ESP Logic
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("KN_ESP")
            if Settings.ESP then
                if not hl then 
                    hl = Instance.new("Highlight", p.Character) 
                    hl.Name = "KN_ESP"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                end
            elseif hl then hl:Destroy() end
        end
    end
end)

print("GALAXY SUPREME V33 LOADED - STEALTH PROTECTED")
