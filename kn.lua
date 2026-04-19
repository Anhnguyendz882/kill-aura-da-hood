--[[ 
    DA HOOD GALAXY V32.1 - ULTRA STEALTH EDITION
    Fix: Heavy Anti-Ban, Anti-Log, Deep Metatable Spoofing.
    Features: Kill Aura Wallbang, Troll Void, Noclip, ESP, Auto Escape.
]]

-- 1. HỆ THỐNG CHỐNG BAN CHUYÊN SÂU (PHẢI CHẠY TRƯỚC UI)
local function Bypass()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local oldIndex = gmt.__index
    local oldNamecall = gmt.__namecall

    -- Chặn Game gửi Log về Server khi phát hiện Speed/Jump/Teleport
    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and self.Name == "MainEvent" then
            if args[1] == "CheckForCheat" or args[1] == "BanMe" or args[1] == "TeleportDetect" then
                return nil -- Chặn gói tin báo cáo hack
            end
        end
        return oldNamecall(self, ...)
    end)

    -- Fake chỉ số để Anticheat không quét được WalkSpeed/JumpPower
    gmt.__index = newcclosure(function(self, b)
        if not checkcaller() and self:IsA("Humanoid") then
            if b == "WalkSpeed" then return 16 end
            if b == "JumpPower" then return 50 end
        end
        return oldIndex(self, b)
    end)
    setreadonly(gmt, true)
    
    -- Chặn các script của game quét bộ nhớ (Adonis Bypass)
    if setfflag then
        setfflag("AbuseReportScreenshot", "False")
        setfflag("CrashPadUploadToS3Only", "False")
    end
end
Bypass()

-- 2. KHỞI TẠO UI RAYFIELD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "DA HOOD V32.1 - KN STEALTH",
   LoadingTitle = "Anti-Ban System: 100% Stealth",
   LoadingSubtitle = "by KN (Anhnguyendz882)",
   ConfigurationSaving = { Enabled = false }
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local MainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")

local Settings = {
    KillAura = false,
    AuraRange = 90, -- Giảm nhẹ Range để tránh bị quét lộ liễu
    Whitelist = {"KN_Admin"},
    WalkSpeed = 16,
    JumpPower = 50,
    ESP = false,
    Noclip = false,
    AutoEscape = true,
    EscapeHealth = 25
}

-- 3. TẠO CÁC TAB
local CombatTab = Window:CreateTab("Combat", 4483362458)
local MoveTab = Window:CreateTab("Movement", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)

CombatTab:CreateToggle({
   Name = "Kill Aura (Wallbang)",
   CurrentValue = false,
   Callback = function(v) Settings.KillAura = v end,
})

CombatTab:CreateButton({
   Name = "Troll: Void Teleport",
   Callback = function()
        local Target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < 25 then Target = p break end
            end
        end
        if Target then
            local OldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            for i = 1, 15 do
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1000, 0)
                Target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                task.wait(0.01)
            end
            LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
        end
   end,
})

MoveTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = function(v) Settings.Noclip = v end })
MoveTab:CreateSlider("Speed", 16, 150, 16, function(v) Settings.WalkSpeed = v end)
MoveTab:CreateSlider("Jump", 50, 200, 50, function(v) Settings.JumpPower = v end)

VisualTab:CreateToggle("ESP", false, function(v) Settings.ESP = v end)
VisualTab:CreateButton("FPS Boost", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") then v.Material = "SmoothPlastic" v.CastShadow = false end
    end
end)

-- 4. VÒNG LẶP XỬ LÝ (TỐI ƯU HÓA TRÁNH LAG)
RunService.Stepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end
    
    -- Noclip
    if Settings.Noclip then
        for _, v in pairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Movement
    Char.Humanoid.WalkSpeed = Settings.WalkSpeed
    Char.Humanoid.JumpPower = Settings.JumpPower

    -- Auto Escape (Teleport trốn khi máu yếu)
    if Settings.AutoEscape and Char.Humanoid.Health > 0 and Char.Humanoid.Health < Settings.EscapeHealth then
        Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)
        task.wait(1.5)
    end

    -- KILL AURA VIP (FIXED)
    if Settings.KillAura and Char:FindFirstChildOfClass("Tool") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local safe = false
                for _, n in pairs(Settings.Whitelist) do if p.Name == n or p.DisplayName == n then safe = true break end end
                
                if not safe and p.Character.Humanoid.Health > 0 then
                    local root = p.Character.HumanoidRootPart
                    if (Char.HumanoidRootPart.Position - root.Position).Magnitude <= Settings.AuraRange then
                        -- Gửi packet ảo để đánh lừa server
                        MainEvent:FireServer("UpdateMousePos", root.Position)
                        MainEvent:FireServer("Shoot", root.Position)
                    end
                end
            end
        end
    end
end)

-- ESP
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("KN_ESP")
            if Settings.ESP then
                if not hl then hl = Instance.new("Highlight", p.Character) hl.Name = "KN_ESP" end
            elseif hl then hl:Destroy() end
        end
    end
end)

Rayfield:Notify({Title = "STEALTH LOADED", Content = "Anti-Ban Mạnh Đã Kích Hoạt!", Duration = 5})
