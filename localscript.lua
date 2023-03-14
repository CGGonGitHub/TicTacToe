local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

ReplicatedStorage.TicTacToeEvent.OnClientEvent:Connect(function(TicTacToe, avaibleClickDetectors, boolean)
	if boolean then
		for _, v in ipairs (TicTacToe.Blocks:GetChildren()) do

			if not table.find(avaibleClickDetectors, tonumber(v.Name)) then continue end
			local clickDetector = v:FindFirstChild("ClickDetector")
			if clickDetector then
				clickDetector.MaxActivationDistance = 32
			end
		end
	elseif not boolean then
		for _, v in ipairs (TicTacToe.Blocks:GetChildren()) do

			local clickDetector = v:FindFirstChild("ClickDetector")
			if clickDetector then
				clickDetector.MaxActivationDistance = 0
			end
		end
	else
		game.Players.LocalPlayer:Kick("fuck u exploiter")
	end
end)
