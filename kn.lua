--[[ 
    DA HOOD GALAXY V40 - TARGET TROLL EDITION
    Developer: KN (Anhnguyendz882)
    Features: Kill Aura, Aimlock, Speed Bypass, Noclip, Target Teleport Troll.
]]

-- 1. SIÊU BYPASS (ANTI-BAN & SPOOFING)
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall
gmt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" and self.Name == "MainEvent" then
        if args[1] == "CheckForCheat" or args[1] == "BanMe" or args[1] == "WS" or args[1] == "TeleportDetect" then 
            return nil 
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(gmt, true)

-- 2. KHỞI TẠO RAYFIELD UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DA HOOD GALAXY V40 - KN",
   LoadingTitle = "Elite Trolling System",
   LoadingSubtitle = "by KN (Anhnguyendz882)",
   ConfigurationSaving = { Enabled = false }
})

-- BIẾN HỆ THỐNG
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local MainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")

local Settings = {
    KillAura = false,
    Aimlock = false,
    AuraRange = 100,
    Speed = 16,
    Jump = 50,
    Noclip = false,
    AutoEscape = true,
    TargetName = "", -- Tên người bị troll
    SafeZone = CFrame.new(-396, 21, -298)
}

-- HÀM LẤY MỤC TIÊU GẦN NHẤT
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

-- TẠO CÁC TAB
local CombatTab = Window:CreateTab("Combat", 4483362458)
local TrollTab = Window:CreateTab("Trolling", 4483362458)
local MoveTab = Window:CreateTab("Movement", 4483362458)
local VisualTab = Window:CreateTab("System", 4483362458)

-- [TAB COMBAT]
CombatTab:CreateToggle({
   Name = "Kill Aura (Wallbang Headshot)",
   CurrentValue = false,
   Callback = function(v) Settings.KillAura = v end,
})

CombatTab:CreateToggle({
   Name = "Aimlock (Lock Tâm Đầu)",
   CurrentValue = false,
   Callback = function(v) Settings.Aimlock = v end,
})

-- [TAB TROLLING - CHỨC NĂNG MỚI]
TrollTab:CreateInput({
   Name = "Nhập Tên Người Muốn Troll",
   PlaceholderText = "Tên hoặc DisplayName...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      Settings.TargetName = Text
   end,
})

TrollTab:CreateButton({
   Name = "EXECUTE: Teleport Void Troll",
   Callback = function()
      local TargetPlayer = nil
      for _, p in pairs(Players:GetPlayers()) do
         if p.Name:lower():sub(1, #Settings.TargetName) == Settings.TargetName:lower() or p.DisplayName:lower():sub(1, #Settings.TargetName) == Settings.TargetName:lower() then
            TargetPlayer = p
            break
         end
      end

      if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
         local OldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
         Rayfield:Notify({Title = "Trolling", Content = "Đang bắt giữ "..TargetPlayer.DisplayName, Duration = 3})
         
         -- 1. Teleport đến mục tiêu
         LocalPlayer.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
         task.wait(0.1)
         
         -- 2. Dìm xuống vực (Void)
         for i = 1, 30 do
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1500, 0)
            TargetPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            task.wait(0.01)
         end
         
         -- 3. Quay về vị trí cũ
         LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
         Rayfield:Notify({Title = "Hoàn tất", Content = "Đã tiễn mục tiêu lên đường!", Duration = 2})
      else
         Rayfield:Notify({Title = "Lỗi", Content = "Không tìm thấy người chơi này!", Duration = 3})
      end
   end,
})

-- [TAB MOVEMENT]
MoveTab:CreateSlider({
   Name = "Speed Bypass (Velocity)",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) Settings.Speed = v end,
})

MoveTab:CreateToggle({
   Name = "Noclip (Xuyên Tường)",
   CurrentValue = false,
   Callback = function(v) Settings.Noclip = v end,
})

-- [TAB SYSTEM]
VisualTab:CreateToggle({
   Name = "Auto Escape (Máu yếu)",
   CurrentValue = true,
   Callback = function(v) Settings.AutoEscape = v end,
})

VisualTab:CreateButton({
   Name = "ESP & FPS Boost",
   Callback = function()
      for _, p in pairs(Players:GetPlayers()) do
          if p ~= LocalPlayer and p.Character then
              if not p.Character:FindFirstChild("Highlight") then
                  Instance.new("Highlight", p.Character)
              end
          end
      end
   end,
})

-- 3. VÒNG LẶP XỬ LÝ TRUNG TÂM
RunService.Stepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end

    -- FIX SPEED BYPASS
    if Settings.Speed > 16 then
        Char.HumanoidRootPart.Velocity = Char.Humanoid.MoveDirection * Settings.Speed + Vector3.new(0, Char.HumanoidRootPart.Velocity.Y, 0)
    end

    -- NOCLIP
    if Settings.Noclip then
        for _, v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- AUTO ESCAPE
    if Settings.AutoEscape and Char.Humanoid.Health > 0 and Char.Humanoid.Health < 25 then
        Char.HumanoidRootPart.CFrame = Settings.SafeZone
        task.wait(1)
    end

    -- KILL AURA & AIMLOCK
    local target = GetClosest()
    if target and (Char.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude <= Settings.AuraRange then
        if Settings.KillAura and Char:FindFirstChildOfClass("Tool") then
            MainEvent:FireServer("UpdateMousePos", target.Character.Head.Position)
            MainEvent:FireServer("Shoot", target.Character.Head.Position)
        end
        if Settings.Aimlock then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

Rayfield:Notify({Title = "GALAXY SUPREME V40", Content = "Dán chuẩn, quậy gắt đi KN!", Duration = 5})
