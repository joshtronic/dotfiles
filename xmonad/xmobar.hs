-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

Config {
	-- font = "-*-fixed-*-*-*-*-12-*-*-*-*-*-*-*"
	--font = "xft:Fixed-11"
	--font = "xft:Monospace-9",
	--font = "xft:Ubuntu Mono:pixelsize=17,dpi=96,rgba=rgb,style=regular,hinting=true,antialias=true,hintstyle=hintfull",
	font = "xft:Ubuntu Mono-11",
	bgColor = "#000000",
	fgColor = "#ffffff",
	position = TopW L 100,
	lowerOnStart = True,
	commands = [
		-- Run Weather "KTPA" ["-t","<tempF>F","-L","64","-H","85","-n","#CEFFAC","-h","#FFB6B0","-l","#96CBFE"] 36000,
		--Run MultiCpu ["-t","CPU <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
		Run MultiCpu ["-t","<bar>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
		-- Run Thermal "THRM" ["-t","iwl4965-temp: <temp>C"] 50,
		-- Run CoreTemp ["-t", "C C", "-L", "40", "-H", "60", "-l", "lightblue", "-n", "white", "-h", "red"] 50,
		Run Memory ["-t","<usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
		--Run Swap ["-t","SWP <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
		-- Run Com "/home/josh/.xmonad/bin/getvolume.sh" [] "myVolume" 10,
		Run Date "%a %b %_d %T" "date" 10,
		Run StdinReader
	],
	sepChar = "%",
	alignSep = "}{",
	-- template = "%StdinReader% }{ %multicpu% <fc=#FFB6B0>:</fc> %memory% <fc=#FFB6B0>:</fc> %KTPA% <fc=#FFB6B0>:</fc> <fc=#FFFFCC>%date%</fc>  "
	-- template = "%StdinReader% }{ %multicpu% <fc=#FFB6B0>:</fc> %memory% <fc=#FFB6B0>:</fc> %KTPA% <fc=#FFB6B0>:</fc> <fc=#FFFFCC>%date%</fc>  "
	template = "%StdinReader% }{ %multicpu% %memory% <fc=#FFB6B0>:</fc> <fc=#FFFFCC>%date%</fc>"

