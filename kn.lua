--[[ 
    DA HOOD ULTIMATE MOBILE - BY KN (GALAXY SUPREME FIX)
    Fix lỗi không hiện menu, tối ưu hóa cho iOS/Android.
    Tính năng: Kill Aura, Whitelist (6+), ESP, FPS Boost, Speed, Jump.
]]

-- 1. TẢI THƯ VIỆN UI RAYFIELD (ỔN ĐỊNH NHẤT CHO MOBILE)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DA HOOD MOBILE - KN PRO",
   LoadingTitle = "Galaxy Supreme V28",
   LoadingSubtitle = "by KN Nguyễn",
   ConfigurationSaving = { Enabled = false }
})

-- 2. CẤU HÌNH HỆ THỐNG
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Settings = {
    KillAura = false,
    AuraRange = 70,
    Whitelist = {"Player1", "Player2", "Player3", "Player4", "Player5", "Player6"}, -- Danh sách trắng
    WalkSpeed = 16,
    JumpPower = 50,
    ESP = false
}

-- 3. TẠO CÁC TAB CHỨC NĂNG
local MainTab = Window:CreateTab("Combat", 4483362458) -- Icon Combat
local MoveTab = Window:CreateTab("Movement", 4483362458)
local VisualTab = Window:CreateTab("System", 4483362458)

-- TAB COMBAT: KILL AURA & WHITELIST
MainTab:CreateToggle({
   Name = "Bật Kill Aura (Cầm súng tự bắn)",
   CurrentValue = false,
   Callback = function(Value) Settings.KillAura = Value end,
})

MainTab:CreateSlider({
   Name = "Phạm vi quét",
   Range = {10, 200},
   Increment = 1,
   Suffix = "m",
   CurrentValue = 70,
   Callback = function(Value) Settings.AuraRange = Value end,
})

MainTab:CreateInput({
   Name = "Thêm Whitelist (Tên thật)",
   PlaceholderText = "Nhập tên người chơi...",
   RemoveTextAfterFocusLost = true,
   Callback = function(Text)
      table.insert(Settings.Whitelist, Text)
      Rayfield:Notify({Title = "Whitelist", Content = "Đã thêm: "..Text, Duration = 3})
   end,
})

-- TAB MOVEMENT: SPEED & JUMP
MoveTab:CreateSlider({
   Name = "Tốc độ chạy",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) Settings.WalkSpeed = Value end,
})

MoveTab:CreateSlider({
   Name = "Độ cao nhảy",
   Range = {50, 300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value) Settings.JumpPower = Value end,
})

-- TAB SYSTEM: ESP & FPS BOOST
VisualTab:CreateToggle({
   Name = "Hiện ESP (Xuyên tường)",
   CurrentValue = false,
   Callback = function(Value) Settings.ESP = Value end,
})

VisualTab:CreateButton({
   Name = "FPS Boost (Giảm Lag Mobile)",
   Callback = function()
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
      Rayfield:Notify({Title = "System", Content = "Đã tối ưu đồ họa!", Duration = 3})
   end,
})

-- 4. VÒNG LẶP XỬ LÝ CHÍNH (FIX LAG)
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end
    
    -- Cập nhật chỉ số di chuyển
    Char.Humanoid.WalkSpeed = Settings.WalkSpeed
    Char.Humanoid.JumpPower = Settings.JumpPower

    -- Xử lý Kill Aura
    if Settings.KillAura then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                -- Kiểm tra Whitelist
                local isWhitelisted = false
                for _, name in pairs(Settings.Whitelist) do
                    if p.Name == name or p.DisplayName == name then isWhitelisted = true break end
                end

                if not isWhitelisted then
                    local dist = (Char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= Settings.AuraRange then
                        local tool = Char:FindFirstChildOfClass("Tool")
                        if tool then
                            -- Gửi tín hiệu bắn của Da Hood
                            ReplicatedStorage.MainEvent:FireServer("Shoot", p.Character.HumanoidRootPart.Position)
                        end
                    end
                end
            end
        end
    end
end)

-- Xử lý ESP
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

Rayfield:Notify({Title = "Thành công", Content = "Script KN PRO đã sẵn sàng!", Duration = 5})
