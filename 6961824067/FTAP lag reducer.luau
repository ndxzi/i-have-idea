local player = game.Players.LocalPlayer
local function deleteUnanchoredParts()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and not obj.Anchored then
			local model = obj:FindFirstAncestorOfClass("Model")
			if not model or not model:FindFirstChildOfClass("Humanoid") then	
			if not (model and model == player.Character) then
					obj:Destroy()
				end
			end
		end
	end
end
deleteUnanchoredParts()
