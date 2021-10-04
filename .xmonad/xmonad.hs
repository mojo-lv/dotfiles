--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import System.Exit
import Graphics.X11.ExtraTypes.XF86
    ( xF86XK_AudioLowerVolume, xF86XK_AudioRaiseVolume, xF86XK_AudioMute,
      xF86XK_MonBrightnessDown, xF86XK_MonBrightnessUp, xF86XK_AudioPlay,
      xF86XK_AudioPrev, xF86XK_AudioNext )

-- layout
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.Fullscreen
    ( fullscreenEventHook, fullscreenManageHook,
      fullscreenSupport, fullscreenFull )
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
    ( Direction2D(D, L, R, U),
      gaps,
      setGaps,
      GapMessage(DecGap, ToggleGaps, IncGap) )

-- hooks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
    ( avoidStruts, docks, manageDocks,
      Direction2D(D, L, R, U) )

-- actions
import XMonad.Actions.CycleWS

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Maybe (maybeToList)
import Control.Monad ( join, when )

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "xfce4-terminal -e fish"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["一","二","三","四","五","六","七","八","九"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#ffffff"
myFocusedBorderColor = "#00cc00"

addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- Audio keys
    , ((0,                    xF86XK_AudioRaiseVolume), spawn "amixer sset 'Master' 5%+")
    , ((0,                    xF86XK_AudioLowerVolume), spawn "amixer sset 'Master' 5%-")
    , ((0,                    xF86XK_AudioMute), spawn "amixer sset 'Master' toggle")

    -- Brightness keys
    , ((0,                    xF86XK_MonBrightnessUp), spawn "xrandr --output eDP-1 --brightness 1")
    , ((0,                    xF86XK_MonBrightnessDown), spawn "xrandr --output eDP-1 --brightness 0.9")

    -- GAPS!!!
    , ((modm,               xK_f     ), sendMessage $ ToggleGaps)
    , ((modm,               xK_g     ), sendMessage $ setGaps [(L,8), (R,8), (U,40), (D,50)])
    , ((modm,               xK_Up    ), sendMessage $ setGaps [(L,0), (R,0), (U,0), (D,50)])
    , ((modm,               xK_Down  ), sendMessage $ setGaps [(L,0), (R,0), (U,40), (D,0)])
    
    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch chrome
    , ((modm .|. shiftMask, xK_c     ), spawn "google-chrome")

    -- launch thunar
    , ((modm .|. shiftMask, xK_e     ), spawn "thunar")

    -- change wallpaper
    , ((modm .|. shiftMask, xK_w     ), spawn "feh --bg-max --randomize ~/Pictures/wallpapers/*")

    -- change poem
    , ((modm .|. shiftMask, xK_d     ), spawn "exec ~/scripts/DailyPoem.sh")

    -- proxy
    , ((modm .|. shiftMask, xK_p     ), spawn "xfce4-terminal -e 'proxychains4 -q fish'")

    -- close focused window 
    , ((modm,               xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Cycle non-empty workspaces
    , ((modm              , xK_Tab   ), moveTo Next NonEmptyWS)
    , ((modm .|. shiftMask, xK_Tab   ), moveTo Prev NonEmptyWS)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_s     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm .|. shiftMask, xK_Left  ), sendMessage (IncMasterN 1))
    , ((modm .|. shiftMask, xK_Up    ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm .|. shiftMask, xK_Right ), sendMessage (IncMasterN (-1)))
    , ((modm .|. shiftMask, xK_Down  ), sendMessage (IncMasterN (-1)))

    -- Quit xmonad
    , ((modm .|. controlMask, xK_Delete), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_r     ), restart "xmonad" True)
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayoutHook = avoidStruts(tiled ||| Mirror tiled ||| Full ||| noBorders (tabbed shrinkText def) ||| Accordion)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = fullscreenManageHook <+> manageDocks <+> composeAll
    [ className =? "qv2ray"         --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen --> doFullFloat
    ]

------------------------------------------------------------------------
--
myFadeHook = composeAll
    [ opaque -- default to opaque
    , isUnfocused --> opacity 0.75
    , isFloating  --> opaque
    , isDialog --> opaque
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myHandleEventHook =
        fadeWindowsEventHook
    <+> handleEventHook def
    <+> XMonad.Hooks.EwmhDesktops.fullscreenEventHook
    <+> ewmhDesktopsEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
myLogHook = do
  fadeWindowsLogHook myFadeHook
  ewmhDesktopsLogHook

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  spawn "exec ~/.xmonad/scripts/startup.sh"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad $ fullscreenSupport $ docks $ ewmh defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        --mouseBindings      = myMouseBindings,

      -- hooks, layouts
        manageHook = myManageHook, 
        layoutHook = gaps [(L,8), (R,8), (U,40), (D,50)] $ smartBorders $ myLayoutHook,
        handleEventHook    = myHandleEventHook,

        logHook            = myLogHook,
        startupHook        = myStartupHook >> addEWMHFullscreen
    }
