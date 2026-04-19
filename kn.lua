--[[ 
    DA HOOD GALAXY SUPREME V32 - FINAL GOD MODE
    Developer: KN (Khánh Nguyễn)
    GitHub: Anhnguyendz882
    Tính năng: Kill Aura Wallbang, Troll Void, Auto Escape, Noclip, ESP, Movement, Anti-Ban.
]]

-- 1. KHỞI TẠO THƯ VIỆN UI RAYFIELD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DA HOOD GALAXY V32 - KN FINAL",
   LoadingTitle = "Vocal Titan: System Finalized",
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
    AuraRange = 100,
    Whitelist = {"KN_Admin", "Anhnguyendz882"}, -- Thêm tên bạn bè vào đây
    WalkSpeed = 16,
    JumpPower = 50,
    ESP = false,
    Noclip = false,
    AutoEscape = true,
    EscapeHealth = 25
}

-- 3. HỆ THỐNG ANTI-BAN (SPOOFING METATABLE)
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldIndex = gmt.__index
gmt.__index = newcclosure(function(self, b)
    if not checkcaller() then
        if b == "WalkSpeed" then return 16 end
        if b == "JumpPower" then return 50 end
    end
    return oldIndex(self, b)
end)
setreadonly(gmt, true)

-- 4. TẠO CÁC TAB CHỨC NĂNG
local CombatTab = Window:CreateTab("Combat & VIP", 4483362458)
local MoveTab = Window:CreateTab("Movement", 4483362458)
local VisualTab = Window:CreateTab("System & ESP", 4483362458)

-- [COMBAT & TROLLING]
CombatTab:CreateToggle({
   Name = "Bật Kill Aura (Wallbang - Xuyên tường)",
   CurrentValue = false,
   Callback = function(Value) Settings.KillAura = Value end,
})

CombatTab:CreateSlider({
   Name = "Phạm vi Kill Aura",
   Range = {10, 250},
   Increment = 1,
   CurrentValue = 100,
   Callback = function(Value) Settings.AuraRange = Value end,
})

CombatTab:CreateButton({
   Name = "TROLL: Teleport Void (Dìm xuống vực)",
   Callback = function()
        local Target = nil
        local MaxDist = 30
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < MaxDist then Target = p MaxDist = d end
            end
        end
        if Target then
            local CurrentPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Trolling", Content = "Đang tiễn biệt "..Target.DisplayName, Duration = 2})
            for i = 1, 25 do
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1500, 0)
                Target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                task.wait(0.01)
            end
            task.wait(0.1)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CurrentPos
        end
   end,
})

CombatTab:CreateInput({
   Name = "Thêm Whitelist",
   PlaceholderText = "Nhập tên...",
   Callback = function(Text) table.insert(Settings.Whitelist, Text) end,
})

-- [MOVEMENT]
MoveTab:CreateToggle({
   Name = "Noclip (Đi xuyên tường)",
   CurrentValue = false,
   Callback = function(Value) Settings.Noclip = Value end,
})

MoveTab:CreateSlider({
   Name = "Tốc độ chạy",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) Settings.WalkSpeed = Value end,
})

MoveTab:CreateSlider({
   Name = "Độ cao nhảy",
   Range = {50, 400},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value) Settings.JumpPower = Value end,
})

-- [SYSTEM & VISUALS]
VisualTab:CreateToggle({
   Name = "Bật ESP (Hiện khung kẻ thù)",
   CurrentValue = false,
   Callback = function(Value) Settings.ESP = Value end,
})

VisualTab:CreateToggle({
   Name = "Auto Escape (Yếu máu tự bay)",
   CurrentValue = true,
   Callback = function(Value) Settings.AutoEscape = Value end,
})

VisualTab:CreateButton({
   Name = "FPS Boost (Mượt cho máy yếu)",
   Callback = function()
      for _, v in pairs(game:GetDescendants()) do
          if v:IsA("Part") or v:IsA("MeshPart") then
              v.Material = Enum.Material.SmoothPlastic
              v.CastShadow = false
          elseif v:IsA("Decal") or v:IsA("Texture") then
              v:Destroy()
          end
      end
   end,
})

-- 5. VÒNG LẶP XỬ LÝ TRUNG TÂM (TỐI ƯU HÓA HEARTBEAT)
RunService.Stepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end
    
    -- Xử lý Noclip
    if Settings.Noclip then
        for _, v in pairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Áp dụng Movement
    Char.Humanoid.WalkSpeed = Settings.WalkSpeed
    Char.Humanoid.JumpPower = Settings.JumpPower

    -- Xử lý Auto Escape (Máu yếu bay lên độ cao 1000)
    if Settings.AutoEscape and Char.Humanoid.Health > 0 and Char.Humanoid.Health < Settings.EscapeHealth then
        Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame * CFrame.new(0, 1000, 0)
        Rayfield:Notify({Title = "CẢNH BÁO", Content = "Đang trốn thoát để hồi máu!", Duration = 3})
        task.wait(2)
    end

    -- XỬ LÝ KILL AURA VIP (FIXED DAMAGE + WALLBANG)
    if Settings.KillAura then
        local tool = Char:FindFirstChildOfClass("Tool")
        if tool then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                    -- Check Whitelist
                    local isWhitelisted = false
                    for _, name in pairs(Settings.Whitelist) do
                        if p.Name == name or p.DisplayName == name then isWhitelisted = true break end
                    end

                    if not isWhitelisted and p.Character.Humanoid.Health > 0 then
                        local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local dist = (Char.HumanoidRootPart.Position - targetRoot.Position).Magnitude
                            if dist <= Settings.AuraRange then
                                -- Gửi tín hiệu bắn trực tiếp vào mục tiêu, bỏ qua vật cản
                                MainEvent:FireServer("UpdateMousePos", targetRoot.Position)
                                MainEvent:FireServer("Shoot", targetRoot.Position)
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
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "KN_ESP"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                end
            elseif hl then hl:Destroy() end
        end
    end
end)

Rayfield:Notify({Title = "KN GALAXY READY", Content = "Tận hưởng bản Final VIP V32!", Duration = 5})
