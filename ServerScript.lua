local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if ReplicatedStorage:FindFirstChild("TicTacToeEvent") then
	
else
	local Event = Instance.new("RemoteEvent")
	Event.Name = "TicTacToeEvent"
	Event.Parent = ReplicatedStorage
end

local TicTacToe = script.Parent
local index
local turnNumber = 0

local ADescription = TicTacToe.NotNeccesarry.DisplayBar.A
local BDescription = TicTacToe.NotNeccesarry.DisplayBar.B

local playerA = nil
local playerB = nil

local blocksA = {}
local blocksB = {}

local avaibleClickDetectors = {}
local UNavaibleClickDetectors = {}

local teleporters = {TicTacToe.TeleporterA.glowpart.ProximityPrompt, TicTacToe.TeleporterB.glowpart.ProximityPrompt}

Players.PlayerAdded:Connect(function(plr) -- event detecting the player join
	plr.CharacterAdded:Connect(function(char) -- event detecting the char of the player
		script.Parent.LocalTicTacToe:Clone().Parent = char
	end)
end)



function startGame()
	table.insert(avaibleClickDetectors, 1)
	table.insert(avaibleClickDetectors, 2)
	table.insert(avaibleClickDetectors, 3)
	table.insert(avaibleClickDetectors, 4)
	table.insert(avaibleClickDetectors, 5)
	table.insert(avaibleClickDetectors, 6)
	table.insert(avaibleClickDetectors, 7)
	table.insert(avaibleClickDetectors, 8)
	table.insert(avaibleClickDetectors, 9)
	local random = math.random(1, 2)
	print(random)
	if random == 1 then
		turn(playerA)
		print("AAAAA")
	elseif random == 2 then
		turn(playerB)
		print("BBB")
	else
		for i, v in Players:GetPlayers() do
			v:Kick("something went wrong, idk")
		end
	end
end

for i, v in pairs(teleporters) do
	v.TriggerEnded:Connect(function(player)
		proxtriggered(player, v.Value.Value, v)
	end)
end

for i, v in TicTacToe.Blocks:GetDescendants() do
	if v:IsA("ClickDetector") then
		v.MouseClick:Connect(function(player)
			clicked(player, tonumber(v.Parent.Name), v)
		end)
	end
end

function turn(player)
	print(player)
	turnNumber = turnNumber + 1
	ReplicatedStorage.TicTacToeEvent:FireClient(player, TicTacToe, avaibleClickDetectors, true)
end

function proxtriggered(player, side, prox)
	if side == "A" then
		playerA = player
		prox.Parent.Color = Color3.fromRGB(255,0,0)
		prox.Enabled = false
		player.Character.HumanoidRootPart.CFrame = TicTacToe.NotNeccesarry.teleportToA.CFrame
		ADescription.DisplayName.SurfaceGui.TextLabel.Text = player.DisplayName
		ADescription.Username.SurfaceGui.TextLabel.Text = player.Name
		ADescription.Headshot.SurfaceGui.ImageLabel.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		occupie()
	elseif side == "B" then
		playerB = player
		prox.Parent.Color = Color3.fromRGB(255,0,0)
		prox.Enabled = false
		player.Character.HumanoidRootPart.CFrame = TicTacToe.NotNeccesarry.teleportToB.CFrame
		BDescription.DisplayName.SurfaceGui.TextLabel.Text = player.DisplayName
		BDescription.Username.SurfaceGui.TextLabel.Text = player.Name
		BDescription.Headshot.SurfaceGui.ImageLabel.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		occupie()
	else
		player:Kick("CGGonRoblox doesn't let u exploit this that easily ;)")
	end
end

function occupie()
	if playerA and playerB then
		startGame()
	end
end

function clicked(player, number, instance)
	ReplicatedStorage.TicTacToeEvent:FireClient(player, TicTacToe, avaibleClickDetectors, false)
	print(avaibleClickDetectors[1])
	if player == playerA then
		local x = TicTacToe.SignsToGet.X:Clone()
		x.Position = TicTacToe.GoToSigns[number].Position
		x.Parent = TicTacToe.PlacedSigns
		for i, v in pairs(avaibleClickDetectors) do
			if v == number then
				index = i
			end
		end
		for i, v in TicTacToe.Blocks:GetChildren() do
			v.ClickDetector.MaxActivationDistance = 0
		end
		TicTacToe.Blocks[number].ClickDetector.MaxActivationDistance = 0
		table.insert(blocksA, number)
		table.insert(UNavaibleClickDetectors, number)
		table.remove(avaibleClickDetectors, index)
		checkForWin(blocksA)
		turn(playerB)
	elseif player == playerB then
		local x = TicTacToe.SignsToGet.O:Clone()
		x.Position = TicTacToe.GoToSigns[number].Position
		x.Parent = TicTacToe.PlacedSigns
		for i, v in pairs(avaibleClickDetectors) do
			if v == number then
				index = i
			end
		end
		table.insert(blocksB, number)
		table.remove(avaibleClickDetectors, index)
		checkForWin(blocksB)
		turn(playerA)
	end
end

function checkForWin(tableSide)
	if table.find(tableSide, 1) and table.find(tableSide, 2) and table.find(tableSide, 3)
		or table.find(tableSide, 4) and table.find(tableSide, 5) and table.find(tableSide, 6)
		or table.find(tableSide, 7) and table.find(tableSide, 8) and table.find(tableSide, 9)
		
		or table.find(tableSide, 1) and table.find(tableSide, 4) and table.find(tableSide, 7)
		or table.find(tableSide, 2) and table.find(tableSide, 5) and table.find(tableSide, 8)
		or table.find(tableSide, 3) and table.find(tableSide, 6) and table.find(tableSide, 9)
		
		or table.find(tableSide, 1) and table.find(tableSide, 5) and table.find(tableSide, 9)
		or table.find(tableSide, 3) and table.find(tableSide, 5) and table.find(tableSide, 7) then
		
		print("win")
		stopGame()
	end
end

Players.PlayerRemoving:Connect(function(player)
	if player == playerA or playerB then
		stopGame(Players)
	end
end)

function stopGame(player, whoGaveUp)
	for i, v in ipairs(TicTacToe.PlacedSigns:GetChildren()) do
		v:Destroy()
	end
	for i, v in pairs(teleporters) do
		v.Enabled = true
		v.Parent.Color = Color3.fromRGB(0, 255, 0)
	end
	for i, v in ipairs(TicTacToe.Blocks:GetChildren()) do
		v.ClickDetector.MaxActivationDistance = 0
	end
	if whoGaveUp == playerA then
		whoGaveUp.Character.Humanoid.Health = 0
		playerB.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 25, 0)
	elseif whoGaveUp == playerB then
		whoGaveUp.Character.Humanoid.Health = 0
		playerA.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 25, 0)
	else
		playerA.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 25, 0)
		playerB.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 25, 0)
	end
	playerA = nil
	playerB = nil
	ADescription.DisplayName.SurfaceGui.TextLabel.Text = "Waiting For Player"
	ADescription.Username.SurfaceGui.TextLabel.Text = "..."
	ADescription.Headshot.SurfaceGui.ImageLabel.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	BDescription.DisplayName.SurfaceGui.TextLabel.Text = "Waiting For Player"
	BDescription.Username.SurfaceGui.TextLabel.Text = "..."
	BDescription.Headshot.SurfaceGui.ImageLabel.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
end
