local Nord = loadstring(game:HttpGet("https://raw.githubusercontent.com/roguerousseau/Nord-0/refs/heads/main/src.lua"))()

local Nord = Nord.init({
	secure = false,
	debug = true
})

local window = Nord:Window({
	loadingWindow = {
		Enabled = true,
	},
	
	Logo = 129006391157524
},Nord.Enum.Style.Dashboard)

local Home = window:Tab("Home")

Home:Title("Home")
Home:Paragraph("This is the home page")
Home:Button("Enabled",Nord.Enum.Components.Button.Primary)
Home:Button("Disabled",Nord.Enum.Components.Button.Secondary)

local Settings = window:Tab("Settings")

Settings:Title("Settings")
Settings:Header("Script Configuration")
Settings:Paragraph("Work in progress")
Settings:Subheader("Account settings")
Settings:Paragraph("No account settings")
