local expression = require("rikai.expression")

describe("expression formatting", function()
	it("groups senses with the same pronunciation", function()
		local results = {
			{ keb_reb_group = "相手:あいて", gloss_group = "companion,company,partner" },
			{ keb_reb_group = "相手:あいて", gloss_group = "addressee,counterparty,other party" },
			{ keb_reb_group = "相手:あいて", gloss_group = "opponent (sports, etc.)" },
		}

		assert.are.same({
			"相手:あいて",
			"",
			"companion,company,partner",
			"addressee,counterparty,other party",
			"opponent (sports, etc.)",
			"",
		}, expression.format_expression_list(results, " ---------- "))
	end)

	it("separates different pronunciations", function()
		local results = {
			{ keb_reb_group = "今日:きょう", gloss_group = "today" },
			{ keb_reb_group = "今日:こんにち", gloss_group = "these days" },
			{ keb_reb_group = "今日:きょう", gloss_group = "at the present day" },
		}

		assert.are.same({
			"今日:きょう",
			"",
			"today",
			"at the present day",
			"",
			" ---------- ",
			"今日:こんにち",
			"",
			"these days",
			"",
		}, expression.format_expression_list(results, " ---------- "))
	end)
end)
