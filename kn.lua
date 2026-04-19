--[[ 
    DA HOOD GALAXY V35 - FINAL CORE (FIX ALL LỖI)
    - Anti-Ban: Bypass Adonis, Anti-Log, Metatable Spoofing.
    - Combat: Kill Aura Wallbang (Sát thương chuẩn), Troll Void.
    - Movement: Speed, Jump, Noclip (Xuyên tường).
    - Survival: Auto Escape (Yếu máu tự bay).
]]

-- 1. SIÊU BYPASS ANTI-BAN (BẮT BUỘC CHẠY TRƯỚC)
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall
local oldIndex = gmt.__index

gmt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" and self.Name == "MainEvent" then
        -- Chặn đứng các gói tin báo cáo hack từ game
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

-- 2. TỰ DỰNG MENU UI (KHÔNG DÙNG LINK NGOÀI - BAO HIỆN)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "KN GALAXY V35 - FINAL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- BIẾN CẤU HÌNH
local Settings = { 
    KillAura = false, Speed = 16, Jump = 50, 
    Noclip = false, Range = 100, AutoEscape = true 
}
local LocalPlayer = game.Players.LocalPlayer
local MainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")

-- HÀM TẠO NÚT NHANH
local function CreateBtn(name, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- CÁC NÚT CHỨC NĂNG
local kBtn = CreateBtn("Kill Aura: OFF", 50, function()
    Settings.KillAura = not Settings.KillAura
    _G.kBtn.Text = "Kill Aura: " .. (Settings.KillAura and "ON" or "OFF")
    _G.kBtn.BackgroundColor3 = Settings.KillAura and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
end) _G.kBtn = kBtn

CreateBtn("TROLL: Void Teleport", 95, function()
    local Target = nil
    for _, p in pairs(game.Players:GetPlayers()) do
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

local nBtn = CreateBtn("Noclip: OFF", 140, function()
    Settings.Noclip = not Settings.Noclip
    _G.nBtn.Text = "Noclip: " .. (Settings.Noclip and "ON" or "OFF")
end) _G.nBtn = nBtn

CreateBtn("Speed: +100", 185, function()
    Settings.Speed = (Settings.Speed == 16) and 120 or 16
end)

CreateBtn("ESP & FPS Boost", 230, function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") then v.Material = "SmoothPlastic" end
    end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("Highlight") then
            Instance.new("Highlight", p.Character)
        end
    end
end)

CreateBtn("ẨN MENU", 275, function() ScreenGui.Enabled = not ScreenGui.Enabled end)

-- 3. VÒNG LẶP XỬ LÝ CHÍNH
game:GetService("RunService").Stepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end
    
    -- Speed & Noclip
    Char.Humanoid.WalkSpeed = Settings.Speed
    if Settings.Noclip then
        for _, v in pairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Auto Escape (Máu < 25)
    if Settings.AutoEscape and Char.Humanoid.Health > 0 and Char.Humanoid.Health < 25 then
        Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame * CFrame.new(0, 1000, 0)
        task.wait(2)
    end

    -- Kill Aura Wallbang (Chỉ bắn khi cầm công cụ/súng)
    if Settings.KillAura and Char:FindFirstChildOfClass("Tool") then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                local root = p.Character.HumanoidRootPart
                if (Char.HumanoidRootPart.Position - root.Position).Magnitude <= Settings.Range then
                    MainEvent:FireServer("UpdateMousePos", root.Position)
                    MainEvent:FireServer("Shoot", root.Position)
                end
            end
        end
    end
end)

print("KN V35 CORE LOADED - KHÔNG LỖI MENU!")
