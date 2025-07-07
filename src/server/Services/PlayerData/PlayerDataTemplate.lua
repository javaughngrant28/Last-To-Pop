export type PlayerDataTemplateType = {
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
}

PlayerDataTemplate = {}

PlayerDataTemplate.Get = function() : PlayerDataTemplateType
	return {
		Keybinds = {
			Attack = {
				PC = 'M1',
				Xbox = 'B Button'
			},
		},
		leaderstats = {
			Wins = 0,
		},

		Equips = {
			Balloon = 'Ahh',
			Weapon = 'Gun1',
		},

		Currency = {
			Coins = 10,
		},
	}
end

return PlayerDataTemplate
