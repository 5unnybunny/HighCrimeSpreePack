Hooks:PostHook(CrimeSpreeTweakData, "init", "data", function(self)
	--remove rewards
	for var1 = 1, 5, 1 do
		self.rewards[var1].amount = 0
	end
	self.all_cosmetics_reward.amount = 0
	self.cosmetic_rewards = {}
	
	--rework cs
	self.modifier_levels = {
		loud = 20,
		forced = 100000,
		stealth = 26
	}
	self.modifiers.forced[1].data.health[1] = 40000
	self.modifiers.forced[1].data.damage[1] = 30000
	self.repeating_modifiers.forced[1].data.health[1] = 40000
	self.repeating_modifiers.forced[1].data.damage[1] = 30000
	
	--remove cost of starting a spree
	self.cost_per_level = 0
	
	--start on 1mil, 2 mil, 3.5mil
	self.starting_levels[1] = 1000000
	self.starting_levels[2] = 2000000
	self.starting_levels[3] = 3500000
		
	--free continues
	self.continue_cost = {
		0,
		0
	}
end)  
