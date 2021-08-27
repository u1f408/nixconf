{ config, pkgs, lib, ... }:

{
  xsession.windowManager.awesome = {
    enable = true;
    # noArgb = true;
  };

  xdg.configFile."awesome/rc.lua".text = ''
    local gears = require("gears")
    local awful = require("awful")
    require("awful.autofocus")
    local wibox = require("wibox")
    local beautiful = require("beautiful")
    local naughty = require("naughty")
    local menubar = require("menubar")

    if awesome.startup_errors then
      naughty.notify({
        preset = naughty.config.presets.critical,
        title = "startup errors",
        text = awesome.startup_errors
      })
    end

    do
      local in_error = false
      awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({
          preset = naughty.config.presets.critical,
          title = "an error occurred",
          text = tostring(err)
        })
        
        in_error = false
      end)
    end

    -- init theme
    beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

    -- variables
    terminal = "alacritty"
    editor = os.getenv("EDITOR") or "nvim"
    editor_cmd = terminal .. " -e " .. editor
    modkey = "Mod4"

    -- define layouts
    awful.layout.layouts = {
      awful.layout.suit.floating,
      awful.layout.suit.tile,
      awful.layout.suit.tile.left,
      awful.layout.suit.tile.bottom,
      awful.layout.suit.tile.top,
      awful.layout.suit.fair,
      awful.layout.suit.max,
      awful.layout.suit.max.fullscreen,
    }

    menubar.utils.terminal = terminal

    -- create some widgets
    w_keyboardlayout = awful.widget.keyboardlayout()
    w_clock = wibox.widget.textclock()

    -- create a wibox for each screen
    local taglist_buttons = gears.table.join(
      awful.button({ }, 1, function(t) t:view_only() end),
      awful.button({ modkey }, 1, function(t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end),
      awful.button({ }, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, function(t)
        if client.focus then
          client.focus:toggle_tag(t)
        end
      end),
      awful.button({ }, 4, function(t)
        awful.tag.viewnext(t.screen)
      end),
      awful.button({ }, 5, function(t)
        awful.tag.viewprev(t.screen)
      end)
    )

    local tasklist_buttons = gears.table.join(
      awful.button({ }, 1, function (c)
        if c == client.focus then
          c.minimized = true
        else
          c:emit_signal(
            "request::activate",
            "tasklist",
            { raise = true }
          )
        end
      end),
      awful.button({ }, 3, function()
        awful.menu.client_list({
          theme = {
            width = 250
          }
        })
      end),
      awful.button({ }, 4, function()
        awful.client.focus.byidx(1)
      end),
      awful.button({ }, 5, function()
        awful.client.focus.byidx(-1)
      end)
    )

    awful.screen.connect_for_each_screen(function(s)
      awful.tag(
        { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
        s,
        awful.layout.layouts[1]
      )

      s.w_promptbox = awful.widget.prompt()
      s.w_layoutbox = awful.widget.layoutbox(s)
      s.w_layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function()
          awful.layout.inc(1)
        end),
        awful.button({ }, 2, function()
          awful.layout.inc(-1)
        end)
      ))

      s.w_taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
      }

      s.w_tasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
      }

      s.w_wibox = awful.wibar({
        position = "top",
        screen = s,
      })
      s.w_wibox:setup {
        layout = wibox.layout.align.horizontal,
        {
          layout = wibox.layout.fixed.horizontal,
          s.w_taglist,
          s.w_promptbox,
        },
        s.w_tasklist,
        {
          layout = wibox.layout.fixed.horizontal,
          w_keyboardlayout,
          wibox.widget.systray(),
          w_clock,
          s.w_layoutbox,
        },
      }
    end)

    -- key bindings
    globalkeys = gears.table.join(
      awful.key({ modkey }, "Left", awful.tag.viewprev),
      awful.key({ modkey }, "Right", awful.tag.viewnext),
      awful.key({ modkey }, "Escape", awful.tag.history.restore),
      awful.key({ modkey, "Shift" }, "Left", function()
        awful.client.swap.byidx(1)
      end),
      awful.key({ modkey, "Shift" }, "Right", function()
        awful.client.swap.byidx(-1)
      end),
      awful.key({ modkey, "Control" }, "Left", function()
        awful.screen.focus_relative(1)
      end),
      awful.key({ modkey, "Control" }, "Right", function()
        awful.screen.focus_relative(-1)
      end),
      awful.key({ modkey }, "u", awful.client.urgent.jumpto),
      awful.key({ modkey }, "Return", function()
        awful.spawn(terminal)
      end),
      awful.key({ modkey, "Shift" }, "r", awesome.restart),
      awful.key({ modkey, "Shift" }, "c", awesome.quit),
      awful.key({ modkey }, "r", function()
        awful.screen.focused().w_promptbox:run()
      end)
    )

    clientkeys = gears.table.join(
      awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
      end),
      awful.key({ modkey, "Shift" }, "q", function(c)
        c:kill()
      end),
      awful.key({ modkey }, "space", awful.client.floating.toggle)
    )

    for i = 1, 9 do
      globalkeys = gears.table.join(
        globalkeys,
        awful.key({ modkey }, "#" .. i + 9, function()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            tag:view_only()
          end
        end),
        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            awful.tag.viewtoggle(tag)
          end
        end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:move_to_tag(tag)
            end
          end
        end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:toggle_tag(tag)
            end
          end
        end)
      )
    end

    clientbuttons = gears.table.join(
      awful.button({ }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
      end),
      awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
      end),
      awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
      end)
    )

    root.keys(globalkeys)

    awful.rules.rules = {
      {
        rule = {},
        properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          raise = true,
          keys = clientkeys,
          buttons = clientbuttons,
          screen = awful.screen.preferred,
          placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
      },
    }

    -- make sure no windows are offscreen at awesome startup
    client.connect_signal("manage", function(c)
      if awesome.startup then
        awful.placement.no_offscreen(c)
      end
    end)

    -- focus follows mouse
    client.connect_signal("mouse::enter", function(c)
      c:emit_signal("request::activate", "mouse_enter", { raise = false })
    end)

    -- focused border color
    client.connect_signal("focus", function(c)
      c.border_color = beautiful.border_focus
    end)
    client.connect_signal("unfocus", function(c)
      c.border_color = beautiful.border_normal
    end)
  '';
}
