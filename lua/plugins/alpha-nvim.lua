return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		-- Set header
		dashboard.section.header.val = {
			"                                                                                                   dddddddd",
			"HHHHHHHHH     HHHHHHHHH  iiii            OOOOOOOOO                               iiii              d::::::d",
			"H:::::::H     H:::::::H i::::i         OO:::::::::OO                            i::::i             d::::::d",
			"H:::::::H     H:::::::H  iiii        OO:::::::::::::OO                           iiii              d::::::d",
			"HH::::::H     H::::::HH             O:::::::OOO:::::::O                                            d:::::d ",
			"  H:::::H     H:::::H  iiiiiii      O::::::O   O::::::O   mmmmmmm    mmmmmmm   iiiiiii     ddddddddd:::::d ",
			"  H:::::H     H:::::H  i:::::i      O:::::O     O:::::O mm:::::::m  m:::::::mm i:::::i   dd::::::::::::::d ",
			"  H::::::HHHHH::::::H   i::::i      O:::::O     O:::::Om::::::::::mm::::::::::m i::::i  d::::::::::::::::d ",
			"  H:::::::::::::::::H   i::::i      O:::::O     O:::::Om::::::::::::::::::::::m i::::i d:::::::ddddd:::::d ",
			"  H:::::::::::::::::H   i::::i      O:::::O     O:::::Om:::::mmm::::::mmm:::::m i::::i d::::::d    d:::::d ",
			"  H::::::HHHHH::::::H   i::::i      O:::::O     O:::::Om::::m   m::::m   m::::m i::::i d:::::d     d:::::d ",
			"  H:::::H     H:::::H   i::::i      O:::::O     O:::::Om::::m   m::::m   m::::m i::::i d:::::d     d:::::d ",
			"  H:::::H     H:::::H   i::::i      O::::::O   O::::::Om::::m   m::::m   m::::m i::::i d:::::d     d:::::d ",
			"HH::::::H     H::::::HHi::::::i     O:::::::OOO:::::::Om::::m   m::::m   m::::mi::::::id::::::ddddd::::::dd",
			"H:::::::H     H:::::::Hi::::::i      OO:::::::::::::OO m::::m   m::::m   m::::mi::::::i d:::::::::::::::::d",
			"H:::::::H     H:::::::Hi::::::i        OO:::::::::OO   m::::m   m::::m   m::::mi::::::i  d:::::::::ddd::::d",
			"HHHHHHHHH     HHHHHHHHHiiiiiiii          OOOOOOOOO     mmmmmm   mmmmmm   mmmmmmiiiiiiii   ddddddddd   ddddd",
		}
		alpha.setup(dashboard.opts)
		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("f", " 🎄  Find file", ":Telescope find_files<CR>"),
			dashboard.button("p", " 🌳  Projects", ":Telescope project<CR>"),
			dashboard.button("r", " 🚀  Recent", ":Telescope oldfiles<CR>"),
			dashboard.button("q", " 🏓  Quit NVIM", ":qa<CR>"),
		}
		-- Send config to alpha
		alpha.setup(dashboard.opts)
	end,
}
