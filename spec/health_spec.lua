require("rikai.health")

describe("health config validation", function()
	it("accepts a valid config", function()
		local ok, err = validateCfg({
			tokenizer = "sudachi",
			dictionaries = {},
			popup_options = {},
		})
		assert.is_true(ok)
		assert.is_nil(err)
	end)

	it("rejects invalid config fields", function()
		for _, field in ipairs({ "tokenizer", "dictionaries", "popup_options" }) do
			local cfg = { tokenizer = "sudachi", dictionaries = {}, popup_options = {} }
			cfg[field] = false
			local ok, err = validateCfg(cfg)
			assert.is_false(ok)
			assert.matches(field, err, 1, true)
		end
	end)
end)
