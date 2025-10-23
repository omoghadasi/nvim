return {
	"psliwka/vim-smoothie",
	event = "VeryLazy",
	init = function()
		vim.g.smoothie_speed_constant_factor = 10 -- عدد بزرگتر = سریع‌تر
		vim.g.smoothie_speed_linear_factor = 10 -- سرعت خطی
		vim.g.smoothie_update_interval = 20 -- میلی‌ثانیه (کمتر = روان‌تر)
		vim.g.smoothie_enabled = 1 -- 1 = فعال، 0 = غیرفعال
	end,
}
