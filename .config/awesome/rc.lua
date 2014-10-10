-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
-- require("xrandr_auto")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
--beautiful.init("/home/h4ct1c/.config/awesome/themes/default/theme.lua")
beautiful.init("/home/h4ct1c/.config/awesome/themes/jd/theme.lua")
--beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
--beautiful.init(awful.util.getdir("config") .. "/default/theme.lua")
--beautiful.init(awful.util.getdir("config") .. "/themes/jd/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,         --1
    awful.layout.suit.tile,             --2
    --awful.layout.suit.tile.left,        --
    --awful.layout.suit.tile.bottom,      --
    --awful.layout.suit.tile.top,         --
    awful.layout.suit.fair,             --3
    --awful.layout.suit.fair.horizontal,  --
    --awful.layout.suit.spiral,           --
    --awful.layout.suit.spiral.dwindle,   --
    awful.layout.suit.max,              --4
    --awful.layout.suit.max.fullscreen,   --
    --awful.layout.suit.magnifier         --
}
-- }}}

-- {{{ Functions

-- Function aliases
local exec  = awful.util.spawn
local sexec = awful.util.spawn_with_shell

-- {{{ dir
function dir(obj,level)
    local s,t = '', type(obj)

    level = level or '  '

    if (t=='nil') or (t=='boolean') or (t=='number') or (t=='string') then
        s = tostring(obj)
        if t=='string' then
            s = '"' .. s .. '"'
        end
    elseif t=='function' then s='function'
    elseif t=='userdata' then s='userdata'
    elseif t=='thread' then s='thread'
    elseif t=='table' then
        s = '{'
        for k,v in pairs(obj) do
            local k_str = tostring(k)
            if type(k)=='string' then
                k_str = '["' .. k_str .. '"]'
            end
            s = s .. k_str .. ' = ' .. dir(v,level .. level) .. ', '
        end
        s = string.sub(s, 1, -3)
        s = s .. '}'
    end

    return s
end
-- }}}

-- {{{ add titlebar
-- not working
function add_titlebar(c)
    if (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end
-- }}}

 -- {{{ Autostart
 -- not used any longer
function run_once(prg,arg_string,pname,screen,notexact)
    -- prg program to run
    -- arg_string: arguments
    -- pname: process name
    -- screen: screen number
    -- examples:
    -- run_once("xscreensaver","-no-splash")
    -- run_once("pidgin",nil,nil,2)
    -- run_once("wicd-client",nil,"/usr/bin/python2 -O /usr/share/wicd/gtk/wicd-client.py")
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    local exact = "-x"
    if notexact then
        exact = ""
    end


    if not arg_string then
        naughty.notify({text = "pgrep -f -u $USER " .. exact .. " '" .. pname .. "' || (" .. prg .. ")"})
        awful.util.spawn_with_shell("pgrep -f -u $USER " .. exact .. " '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER " .. exact .. " '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end


-- }}}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
  names  = { "term", "web", "vim", "float", "eclipse", 6 },
  layout = { layouts[2], layouts[2], layouts[3], layouts[1], layouts[1],
             layouts[4],
}}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
    --awful.tag.setproperty(tags[s][5], "mwfact", 0.13)
    awful.tag.setproperty(tags[s][6], "hide",   true)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- {{{ Widgets

-- {{{ Reusable separators
spacer    = wibox.widget.textbox()
separator = wibox.widget.imagebox()
spacer:set_text(" ")
separator:set_image(beautiful.widget_sep)
-- }}}

-- {{{ CPUBars
-- Initialize widgets
cpu = {
    fi = awful.widget.progressbar(),
    se = awful.widget.progressbar(),
    th = awful.widget.progressbar(),
    fo = awful.widget.progressbar()
}
-- Progressbar properties
for _, w in pairs(cpu) do
  w:set_width(6)
  w:set_height(12)
  w:set_vertical(true)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_border_color(beautiful.border_widget)
  w:set_color({ type = "linear",
                     from = { 0, 0 }, to = { 0, 20 },
                     stops = { { 0, beautiful.fg_end_widget },
                               { 0.5, beautiful.fg_center_widget },
                               { 1, beautiful.fg_widget } }
                   })
  -- Register buttons
  w.buttons(awful.util.table.join(
    awful.button({ }, 1, function () sexec("htop") end)
  ))
end
-- Enable caching
vicious.cache(vicious.widgets.cpu)
-- Register widgets
vicious.register(cpu.fi, vicious.widgets.cpu, "$2")
vicious.register(cpu.se, vicious.widgets.cpu, "$3")
vicious.register(cpu.th, vicious.widgets.cpu, "$4")
vicious.register(cpu.fo, vicious.widgets.cpu, "$5")
-- }}}

-- {{{ CPUGraph and temperature
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
-- Initialize widgets
cpugraph  = awful.widget.graph()
tzswidget = wibox.widget.textbox()
-- Graph properties
cpugraph:set_width(40)
cpugraph:set_height(14)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_color({ type = "linear",
                     from = { 0, 0 }, to = { 0, 20 },
                     stops = { { 0, beautiful.fg_end_widget },
                               { 0.5, beautiful.fg_center_widget },
                               { 1, beautiful.fg_widget } }
                   })
 -- Register widgets
vicious.register(cpugraph,  vicious.widgets.cpu,     "$1")
vicious.register(tzswidget, vicious.widgets.thermal, "$1C", 19, "thermal_zone0")
--  }}}

-- {{{ Battery state
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_bat)
-- Initialize widget
batwidget = wibox.widget.textbox()
-- Register widget
--vicious.register(batwidget, vicious.widgets.bat, "$1$2%$3", 61, "BAT0")
local critBat = nil
vicious.register(batwidget, vicious.widgets.bat,
    function(widget, args)
        if args[1] == "−" then
            if args[2] < 5 then
                critBat = naughty.notify({
                    preset = naughty.config.presets.critical,
                    timeout = 60,
                    text = "critical battery"})
            end
            return '<span color="#CC9393">'
                .. args[1] .. args[2] .. "%" .. args[3]
                .. '</span>'
        end
        if critBat ~= nil then
            naughty.destroy(critBat)
            critBat = nil
        end
        return args[1] .. args[2] .. "%" .. args[3]
    end, 61, "BAT0")
-- }}}

-- {{{ Memory usage
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
-- Initialize widget
membar = awful.widget.progressbar()
-- Pogressbar properties
membar:set_width(10)
membar:set_height(12)
membar:set_vertical(true)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_border_color(beautiful.border_widget)
membar:set_color({ type = "linear",
                     from = { 0, 0 }, to = { 0, 20 },
                     stops = { { 0, beautiful.fg_end_widget },
                               { 0.5, beautiful.fg_center_widget },
                               { 1, beautiful.fg_widget } }
                   })
-- Register widget
vicious.register(membar, vicious.widgets.mem, "$1", 13)
-- }}}
--
-- {{{ Network usage
dnicon = wibox.widget.imagebox()
upicon = wibox.widget.imagebox()
dnicon:set_image(beautiful.widget_net)
upicon:set_image(beautiful.widget_netup)
-- Initialize widget
netwidget = wibox.widget.textbox()
-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netdn_widget ..'">${wlan0 down_kb}</span> <span color="'
  .. beautiful.fg_netup_widget ..'">${wlan0 up_kb}</span>', 3)

-- }}}
--
-- {{{ Pacman Widget
pacwidget = wibox.widget.textbox()

pacwidget_t = awful.tooltip({ objects = { pacwidget},})

vicious.register(pacwidget, vicious.widgets.pkg,
                function(widget,args)
                    local io = { popen = io.popen }
                    local s = io.popen("pacman -Qu")
                    local str = ''

                    for line in s:lines() do
                        str = str .. line .. "\n"
                    end
                    pacwidget_t:set_text(str)
                    s:close()
                    return "U: " .. args[1]
                end, 1800, "Arch")
-- }}}
--
-- {{{ Netinfo Widget
-- function to call bash script and return its output.
netinfowidget = wibox.widget.textbox()
function get_ips()
    local fd = io.popen("~/.bin/awesome/wlaninfo")
    local str = fd:read("*all")
    return str
end
-- Set up a timer to refresh every hour. Useful for ADSL connections.
mytimer = timer({ timeout = 60 })
mytimer:connect_signal("timeout", function() netinfowidget:set_text(get_ips()) end)
mytimer:start()
-- }}}
--
-- {{{ File system usage
fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.widget_fs)
-- Initialize widgets
fs = {
  r = awful.widget.progressbar(),
  d = awful.widget.progressbar(),
  w = awful.widget.progressbar(),
}
-- Progressbar properties
for _, w in pairs(fs) do
  w:set_width(5)
  w:set_height(12)
  w:set_vertical(true)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_border_color(beautiful.border_widget)
  w:set_color(beautiful.fg_widget)
  w:set_color({ type = "linear",
                     from = { 0, 0 }, to = { 0, 20 },
                     stops = { { 0, beautiful.fg_end_widget },
                               { 0.5, beautiful.fg_center_widget },
                               { 1, beautiful.fg_widget } }
                   })
  -- Register buttons
  w.buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("baobab", false) end)
  ))
end
-- Enable caching
vicious.cache(vicious.widgets.fs)
-- Register widgets
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",       60)
vicious.register(fs.d, vicious.widgets.fs, "${/mnt/data used_p}", 60)
vicious.register(fs.w, vicious.widgets.fs, "${/mnt/win used_p}", 60)
-- }}}
--
-- {{{ Volume level
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = wibox.widget.textbox()
-- Progressbar properties
volbar:set_width(10)
volbar:set_height(12)
volbar:set_vertical(true)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_border_color(beautiful.border_widget)
volbar:set_color({ type = "linear",
                     from = { 0, 0 }, to = { 0, 20 },
                     stops = { { 0, beautiful.fg_end_widget },
                               { 0.5, beautiful.fg_center_widget },
                               { 1, beautiful.fg_widget } }
                   })
-- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume, "$1",  2, "Master")
vicious.register(volwidget, vicious.widgets.volume, "$1%", 2, "Master")
-- Register buttons
volbar.buttons(awful.util.table.join(
   awful.button({ }, 1, function () exec("kmix") end),
   awful.button({ }, 2, function () exec("amixer -q sset Master toggle")   end),
   awful.button({ }, 4, function () exec("amixer -q sset PCM 2dB+", false) end),
   awful.button({ }, 5, function () exec("amixer -q sset PCM 2dB-", false) end)
)) -- Register assigned buttons
volwidget.buttons(volbar:buttons())
-- }}}
--
-- }}}
--
-- {{{ Wibox Init
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
                           ))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(volicon)
    right_layout:add(volwidget)
    right_layout:add(volbar)
    right_layout:add(separator)
    right_layout:add(netinfowidget)
    right_layout:add(dnicon)
    right_layout:add(netwidget)
    right_layout:add(upicon)
    right_layout:add(separator)
    right_layout:add(fsicon)
    right_layout:add(fs.r)
    right_layout:add(fs.d)
    right_layout:add(fs.w)
    right_layout:add(separator)
    right_layout:add(memicon)
    right_layout:add(membar)
    right_layout:add(separator)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(separator)
    right_layout:add(cpuicon)
    right_layout:add(cpu.fi)
    right_layout:add(cpu.se)
    right_layout:add(cpu.th)
    right_layout:add(cpu.fo)
    --right_layout:add(cpugraph)
    right_layout:add(separator)
    right_layout:add(tzswidget)
    right_layout:add(separator)
    right_layout:add(pacwidget)
    right_layout:add(separator)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}
---}}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "k",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "j",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "h",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "l",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "g", function () awful.util.spawn("sunflower") end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "+",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "-",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    awful.key({ modkey, "Shift" }, "t", function (c)
        if awful.titlebar(c) then
            --awful.titlebar(c, {size = 0})
        else add_titlebar(c)
        end
    end),
    awful.key({ modkey, "Shift"   }, "Left",
    function (c)
        local curidx = awful.tag.getidx()
        if curidx == 1 then
            awful.client.movetotag(tags[client.focus.screen][5])
        else
            awful.client.movetotag(tags[client.focus.screen][curidx - 1])
        end
        awful.tag.viewprev()
    end),
    awful.key({ modkey, "Shift"   }, "Right",
    function (c)
        local curidx = awful.tag.getidx()
        if curidx == 5 then
            awful.client.movetotag(tags[client.focus.screen][1])
        else
            awful.client.movetotag(tags[client.focus.screen][curidx + 1])
        end
        awful.tag.viewnext()
    end)
    --awful.key({ modkey, "Shift" }, "t", function(c) add_titlebar(c) end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Sunflower" },
      properties = { floating = true } },
    --{ rule = { class = "Chromium" },
       --properties = { tag = tags[1][2] } },
    { rule = { class = "Eclipse" },
       properties = { tag = tags[1][5] } },
    -- make flash fullscreen float
    { rule = { class = "Exe" },
       properties = { floating = true, border_width = "0" } },
    { rule = { class = "Dwb", instance = "dwb", name = "dwb" },
       properties = { floating = true, border_width = "0"} },
    -- make silverlight fullscreen float
    { rule = { class = "Wine", instance = "pluginloader.exe" },
       properties = { floating = true, border_width = "0"} },
    --{ rule = { class = "ij-ImageJ" },
      -- properties = { tag = tags[1][4] } },

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
-- {{{ Manage signal handler
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    --c:connect_signal("mouse::enter", function(c)
        --if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            --and awful.client.focus.filter(c) then
            --client.focus = c
        --end
    --end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)
-- }}}
-- {{{ Focus signal handlers
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c) or layout == "floating"
        then if not c.fullscreen then c.above       =  true  end
        else                          c.above       =  false end
    end
  end)
end
-- }}}
-- }}}
--run_once("chromium",nil,"/usr/lib/chromium/chromium --ppapi-flash-path=/usr/lib/PepperFlash/libpepflashplayer.so --ppapi-flash-version=11.5.31.137")
--run_once("chromium",nil,nil,nil,true)
--run_once("wicd-client","--tray","/usr/bin/python2 -O /usr/share/wicd/gtk/wicd-client.py")
--run_once("xterm")
--run_once("xscreensaver","-no-splash")
sexec("run_once xscreensaver -no-splash")
--sexec("run_once wicd-client --tray")
sexec("run_once xterm")
sexec("run_once chromium")
--sexec("run_once gajim")
--sexec("run_really xscreensaver-command --lock")
-- vim: filetype=lua:expandtab:fdm=marker:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
