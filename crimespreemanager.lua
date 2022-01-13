Hooks:PostHook(CrimeSpreeTweakData, "init", "HCSP_crimespreemanager", function(self)
	function CrimeSpreeManager:_setup_modifiers()
		if not self:is_active() then
			return
		end
	
		if self._modifiers then
			for _, modifier in ipairs(self._modifiers) do
				modifier:destroy()
			end
		end
	
		self._modifiers = {}
	
		local modifiers_to_activate = {}
	
		for _, active_data in ipairs(self:server_active_modifiers()) do
			local modifier = self:get_modifier(active_data.id)
	
			if modifier then
				local new_data = modifiers_to_activate[modifier.class] or {}
	
				for key, value_data in pairs(modifier.data) do
					local value = value_data[1]
					local stack_method = value_data[2]
	
					if stack_method == "none" then
						new_data[key] = value
					elseif stack_method == "add" then
						new_data[key] = (new_data[key] or 0) + value
					elseif stack_method == "sub" then
						new_data[key] = (new_data[key] or 0) - value
					elseif stack_method == "min" then
						new_data[key] = math.min(new_data[key] or math.huge, value)
					elseif stack_method == "max" then
						new_data[key] = math.max(new_data[key] or -math.huge, value)
					end
				end
	
				
				--modifiers_to_activate[modifier.class] = new_data
				for class, data in pairs(new_data) do
				local mod_class = _G[class]
				
				if mod_class then
					managers.modifiers:add_modifier(mod_class:new(data), "crime_spree")
				else
					Application:error("Can not activate modifier as it does not exist!", class)
				end
	
			else
				Application:error("[CrimeSpreeManager] Can not activate modifier as it does not exist! Was it deleted?", active_data.id)
			end
		end
	
		for class, data in pairs(modifiers_to_activate) do
			local mod_class = _G[class]
	
			if mod_class then
				managers.modifiers:add_modifier(mod_class:new(data), "crime_spree")
			else
				Application:error("Can not activate modifier as it does not exist!", class)
			end
		end
	end
end)