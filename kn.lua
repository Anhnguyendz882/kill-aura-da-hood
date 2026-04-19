--[[ 
    DA HOOD ULTIMATE MOBILE - BY KN (Galaxy Supreme Edition)
    Tối ưu: iOS, Android, Termux-ready
    Tính năng: Kill Aura (No Miss), Whitelist, ESP, FPS Boost, Movement.
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7Lib/UI-Library/main/Source.lua"))()
local Window = Library:CreateWindow("DA HOOD - KN PRO")

-- HỆ THỐNG BIẾN & CẤU HÌNH
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Settings = {
    KillAura = false,
    AuraRange = 70,
    Whitelist = {"KN_Friend1", "KN_Friend2", "KN_Friend3", "KN_Friend4", "KN_Friend5", "KN_Friend6"}, 
    WalkSpeed = 16,
    JumpPower = 50,
    ESP = false,
    FPSBoost = false
}

-- [TAB 1: CHIẾN ĐẤU - KILL AURA]
local CombatTab = Window:CreateTab("Combat")

CombatTab:CreateToggle("Bật Kill Aura (Auto Shoot)", function(state)
    Settings.KillAura = state
end)

CombatTab:CreateSlider("Khoảng cách diệt", 10, 250, 70, function(val)
    Settings.AuraRange = val
end)

CombatTab:CreateTextBox("Thêm Whitelist", "Nhập tên...", function(text)
    table.insert(Settings.Whitelist, text)
    print("Đã thêm vào danh sách trắng: " .. text)
end)

-- [TAB 2: DI CHUYỂN]
local MoveTab = Window:CreateTab("Movement")

MoveTab:CreateSlider("Tốc độ chạy", 16, 200, 16, function(val)
    Settings.WalkSpeed = val
end)

MoveTab:CreateSlider("Độ cao nhảy", 50, 300, 50, function(val)
    Settings.JumpPower = val
end)

-- [TAB 3: HỆ THỐNG & ESP]
local SystemTab = Window:CreateTab("System & Visuals")

SystemTab:CreateToggle("Hiện ESP Kẻ Thù", function(state)
    Settings.ESP = state
end)

SystemTab:CreateButton("FPS Boost (No Lag Mobile)", function()
    Settings.FPSBoost = true
    local l = game:GetService("Lighting")
    l.GlobalShadows = false
    l.FogEnd = 9e9
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end)

-- [VÒNG LẶP XỬ LÝ TRUNG TÂM]
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") or not Char:FindFirstChild("HumanoidRootPart") then return end
    
    -- Cập nhật Speed và Jump liên tục
    Char.Humanoid.WalkSpeed = Settings.WalkSpeed
    Char.Humanoid.JumpPower = Settings.JumpPower

    -- LOGIC KILL AURA (QUÉT VÀ DIỆT)
    if Settings.KillAura then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                if p.Character.Humanoid.Health > 0 then
                    -- Kiểm tra Whitelist
                    local isWhitelisted = false
                    for _, name in pairs(Settings.Whitelist) do
                        if p.Name == name or p.DisplayName == name then
                            isWhitelisted = true
                            break
                        end
                    end

                    if not isWhitelisted then
                        local distance = (Char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= Settings.AuraRange then
                            local tool = Char:FindFirstChildOfClass("Tool")
                            if tool then
                                -- Bắn trực tiếp vào đối thủ (MainEvent của Da Hood)
                                ReplicatedStorage.MainEvent:FireServer("Shoot", p.Character.HumanoidRootPart.Position)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- LOGIC ESP (VẼ KHUNG)
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("KN_ESP")
            if Settings.ESP then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "KN_ESP"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = p.Character
                end
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)

print("KN PRO SCRIPT LOADED - READY FOR GITHUB")
