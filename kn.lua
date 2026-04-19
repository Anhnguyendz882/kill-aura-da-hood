--[[ 
    DA HOOD PROFESSIONAL SCRIPT - GALAXY SUPREME V28
    Developer: KN (Khánh Nguyễn)
    Features: Kill Aura (Fixed), Trolling (Void), Whitelist, ESP, FPS Boost, Movement.
    Hotkeys: RightControl (Ẩn/Hiện Menu)
]]

-- 1. KHỞI TẠO THƯ VIỆN UI RAYFIELD (CHUYÊN NGHIỆP & ỔN ĐỊNH)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DA HOOD GALAXY V28 - KN PRO",
   LoadingTitle = "Vocal Titan System Online",
   LoadingSubtitle = "by KN (Anhnguyendz882)",
   ConfigurationSaving = { Enabled = false }
})

-- 2. HỆ THỐNG BIẾN TOÀN CỤC
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MainEvent = ReplicatedStorage:WaitForChild("MainEvent")

local Settings = {
    KillAura = false,
    AuraRange = 75,
    Whitelist = {"KN_Nguyên", "KN_Admin", "Anhnguyendz882"}, -- Điền tên bạn bè vào đây
    WalkSpeed = 16,
    JumpPower = 50,
    ESP = false,
    TrollAuto = false
}

-- 3. TẠO CÁC TAB CHỨC NĂNG
local CombatTab = Window:CreateTab("Combat & Kill", 4483362458)
local TrollTab = Window:CreateTab("Trolling", 4483362458)
local MoveTab = Window:CreateTab("Movement", 4483362458)
local VisualTab = Window:CreateTab("System & ESP", 4483362458)

-- [COMBAT: KILL AURA CHUẨN VIDEO]
CombatTab:CreateToggle({
   Name = "Bật Kill Aura (Damage Fix)",
   CurrentValue = false,
   Callback = function(Value) Settings.KillAura = Value end,
})

CombatTab:CreateSlider({
   Name = "Phạm vi quét",
   Range = {10, 150},
   Increment = 1,
   CurrentValue = 75,
   Callback = function(Value) Settings.AuraRange = Value end,
})

CombatTab:CreateInput({
   Name = "Thêm vào Whitelist",
   PlaceholderText = "Nhập tên người chơi...",
   Callback = function(Text)
       table.insert(Settings.Whitelist, Text)
       Rayfield:Notify({Title = "Hệ thống", Content = "Đã bảo vệ "..Text, Duration = 3})
   end,
})

-- [TROLLING: VOID TELEPORT]
TrollTab:CreateButton({
   Name = "Troll: Đưa người gần nhất vào Hư Vô (Void)",
   Callback = function()
        local Target = nil
        local MaxDist = 25
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < MaxDist then Target = p MaxDist = d end
            end
        end

        if Target then
            local OldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Trolling", Content = "Đang tiễn "..Target.DisplayName.." ra đảo...", Duration = 2})
            
            -- Thực hiện dịch chuyển liên tục để tránh bị lỗi vị trí
            for i = 1, 15 do
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1000, 0) -- Hố đen hư vô
                Target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                task.wait(0.02)
            end
            
            task.wait(0.1)
            LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos -- Quay về chỗ cũ
        else
            Rayfield:Notify({Title = "Lỗi", Content = "Không tìm thấy ai đủ gần!", Duration = 3})
        end
   end,
})

-- [MOVEMENT & SYSTEM]
MoveTab:CreateSlider("Tốc độ", 16, 250, 16, function(v) Settings.WalkSpeed = v end)
MoveTab:CreateSlider("Nhảy cao", 50, 300, 50, function(v) Settings.JumpPower = v end)

VisualTab:CreateToggle("Hiện ESP Kẻ Thù", false, function(v) Settings.ESP = v end)
VisualTab:CreateButton("Siêu tối ưu FPS (Bản cực mượt)", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end)

-- 4. VÒNG LẶP LOGIC CHÍNH (XỬ LÝ KILL AURA & MOVEMENT)
RunService.Stepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    
    -- Áp dụng di chuyển
    Char.Humanoid.WalkSpeed = Settings.WalkSpeed
    Char.Humanoid.JumpPower = Settings.JumpPower

    -- XỬ LÝ KILL AURA (QUÉT & BẮN)
    if Settings.KillAura then
        local tool = Char:FindFirstChildOfClass("Tool")
        if tool then -- Phải cầm súng
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                    -- Kiểm tra Whitelist
                    local safe = false
                    for _, name in pairs(Settings.Whitelist) do
                        if p.Name == name or p.DisplayName == name then safe = true break end
                    end

                    if not safe and p.Character.Humanoid.Health > 0 then
                        local root = p.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local d = (Char.HumanoidRootPart.Position - root.Position).Magnitude
                            if d <= Settings.AuraRange then
                                -- ĐÂY LÀ PHẦN QUAN TRỌNG NHẤT ĐỂ KILL AURA CÓ TÁC DỤNG
                                MainEvent:FireServer("UpdateMousePos", root.Position)
                                MainEvent:FireServer("Shoot", root.Position)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- LOGIC ESP (VẼ HIGHLIGHT)
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

Rayfield:Notify({Title = "Thành công", Content = "Script Galaxy V28 đã nạp hoàn tất!", Duration = 5})
