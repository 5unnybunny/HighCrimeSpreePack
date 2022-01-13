local csbad = CrimeSpreeManager._setup_modifiers
--optimising the function
function CrimeSpreeManager:_setup_modifiers()
	csbad(self)
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
					else
						new_data[key] = math.max(new_data[key] or -math.huge, value)
					end
				end
				managers.modifiers:add_modifier(new_data, "crime_spree")
			else
				Application:error("[CrimeSpreeManager] Can not activate modifier as it does not exist! Was it deleted?", active_data.id)
			end
		end
	end
end


local server_modifiers = CrimeSpreeManager.server_active_modifiers

function CrimeSpreeManager:server_active_modifiers()
	server_modifiers(self)
		if not self:_is_host() then
			return self._global.server_modifiers or {}
			self:_add_frame_callback(callback(managers.menu_component, managers.menu_component, "refresh_crime_spree_details_gui"))
		return {}
		else
			return self:in_progress() and self:active_modifiers() or {}
		end
	end
end

local set_cs_modifiers = CrimeSpreeManager.set_server_modifier

function CrimeSpreeManager:set_server_modifier(modifier_id, modifier_level, announce)
	set_cs_modifiers(self)
		self._global.server_modifiers = self._global.server_modifiers or {}

		for _, data in ipairs(self._global.server_modifiers) do
			if data.id == modifier_id then
				Application:error("Can not add the same server modifier twice!", modifier_id)

				return
			end
		end

		table.insert(self._global.server_modifiers, {
			id = modifier_id,
			level = modifier_level
		})
		--self:_add_frame_callback(callback(managers.menu_component, managers.menu_component, "refresh_crime_spree_details_gui"))

		if announce then
			self:_add_frame_callback(callback(self, self, "_announce_modifier", modifier_id))
		end

	end
end