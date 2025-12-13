local L = game:GetService("Lighting")
local W = game:GetService("Workspace")
local P = game:GetService("Players")
local A = P.LocalPlayer
local T = W:FindFirstChildOfClass("Terrain")
local S = settings()

local function O(v)
    if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
        pcall(function() 
            v.Transparency = 1 
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
            if v:IsA("BasePart") then
                v.BrickColor = BrickColor.new(155, 155, 155)
            end
        end)
        local c = v:FindFirstChildOfClass("Texture")
        if c then
            c:Destroy()
        end
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
        pcall(function() 
            v.Enabled = false
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            end
        end)
    elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Explosion") or v:IsA("Highlight") or v:IsA("Shimmer") or v:IsA("SpotLight") then
        v:Destroy() 
    elseif v:IsA("Sound") then
        v:Stop()
    elseif v:IsA("Animation") or v:IsA("AnimationTrack") then
        v:Destroy()
    elseif v:IsA("Humanoid") then
        for _, t in next, v:GetPlayingAnimationTracks() do
            t:Stop()
        end
    end
end

task.spawn(function()
    S.Rendering.QualityLevel = Enum.QualityLevel.Level01
    S.Rendering.EagerBulkExecution = false
    W.ClientAnimatorThrottling = Enum.ClientAnimatorThrottlingMode.Enabled
    W.InterpolationThrottling = Enum.InterpolationThrottlingMode.Enabled
    W.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
end)

task.spawn(function()
    L.GlobalShadows = false
    L.FogStart = 0
    L.FogEnd = 0
    L.Brightness = 0
    L.OutdoorAmbient = Color3.new(0, 0, 0)
    L.Ambient = Color3.new(0, 0, 0)
    
    for _, c in ipairs(L:GetChildren()) do
        if c:IsA("Sky") or c:IsA("SunRaysEffect") or c:IsA("BloomEffect") or c:IsA("ColorCorrectionEffect") or c:IsA("BlurEffect") or c:IsA("DepthOfFieldEffect") then
            c:Destroy() 
        end
    end
    
    L.ChildAdded:Connect(function(v)
        if v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v:Destroy()
        end
    end)
end)

task.spawn(function()
    if T then
        T.WaterTransparency = 0
        T.WaterWaveSize = 0
        T.WaterWaveSpeed = 0
        T.WaterReflectance = 0
        T.WaterColor = Color3.new(0, 0, 0)
        T.MaterialColors = Enum.MaterialColors.Plain
    end
end)

task.spawn(function()
    local C = W.CurrentCamera
    local R = A.Character
    if C then
        C.FieldOfView = 1
        C.CameraSubject = nil
        C.CameraType = Enum.CameraType.Scriptable
        C.NearClip = 0.001
        
        if C:FindFirstChild("FarPlane") then
            C.FarPlane = 0
        end
        if C:GetAttribute("FarZ") then
            C:SetAttribute("FarZ", 0)
        end
    end
    
    if R then
        R.Archivable = false
        R.Parent = nil
        for _, v in R:GetDescendants() do
             if v.Name:lower():match("arm") or v.Name:lower():match("hand") or v.Name:lower():match("viewmodel") then
                v:Destroy()
            end
        end
    end
end)

task.spawn(function()
    for _, i in next, W:GetDescendants() do
        O(i)
    end
    for _, i in next, getnilinstances() do
        O(i)
        for _, d in next, i:GetDescendants() do
            O(d)
        end
    end
end)

W.DescendantAdded:Connect(function(v)
    task.spawn(function()
        O(v)
    end)
end)

collectgarbage("collect")
