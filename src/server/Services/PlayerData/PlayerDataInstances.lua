export type PlayerDataInstancesType = {
	Keybinds: {
		[string]: {
			PC: string,
			Xbox: string,
		}
	},

	Equips: {
		Balloon: string,
		Weapon: string,
	},

	leaderstats: {
		Wins: number
	},

	Currency: {
		Coins: number
	},

	IsPlaying: boolean
}


local PlayerDataInstances = {}

PlayerDataInstances.Get = function() : PlayerDataInstancesType
	return {
		FinishedLoading = false,
		Keybinds = {},

		Equips = {
			Balloon = '',
			Weapon = '',
		},
		
		leaderstats = {
			Wins = 0,
		},
		Currency = {
			Coins = 10,
		},

		IsPlaying = false,
	}
end

return PlayerDataInstances

