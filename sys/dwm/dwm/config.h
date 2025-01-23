/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx = 3; /* border pixel of windows */
static const unsigned int snap = 4;     /* snap pixel */
static const unsigned int gappih = 6;   /* horiz inner gap between windows */
static const unsigned int gappiv = 6;   /* vert inner gap between windows */
static const unsigned int gappoh =
    6; /* horiz outer gap between windows and screen edge */
static const unsigned int gappov =
    6; /* vert outer gap between windows and screen edge */
static int smartgaps =
    0; /* 1 means no outer gap when there is only one window */
static const int swallowfloating =
    0;                        /* 1 means swallow floating windows by default */
static const int showbar = 1; /* 0 means no bar */
static const int topbar = 1;  /* 0 means bottom bar */
static const int horizpadbar = -6; /* horizontal padding for statusbar */
static const int vertpadbar = 0;   /* vertical padding for statusbar */
static const int vertpad = 6;      /* vertical padding of bar */
static const int sidepad = 6;      /* horizontal padding of bar */
static const char *fonts[] = {
    "Iosevka:style:medium:size=16",
    "JetBrainsMono Nerd Font Mono:style:medium:size=19",
    "Fira Code:size=16",
    "font-awesome:size=16",
    "noto-fonts-emoji:size=16",
    "siji-ttf:size=16",
    "ttf-unifont:size=16",
    "ttf-joypixels:size=16",
    "RobotoMono Nerd Font:size=16",
    "NotoEmoji:size=16",
    "Noto Sans CJK JP:size=16"};
static const char dmenufont[] = "Fira Code:size=20";
static const char col_gray1[] = "#222222";
static const char col_gray2[] = "#444444";
static const char col_gray3[] = "#bbbbbb";
static const char col_gray4[] = "#eeeeee";
static const char col_cyan[] = "#005577";

static const char black[] = "#2A303C";
static const char white[] = "#D8DEE9";
static const char gray2[] = "#3B4252"; // unfocused window border
static const char gray3[] = "#606672";
static const char gray4[] = "#6d8dad";
static const char blue[] = "#81A1C1"; // focused window border
static const char green[] = "#89b482";
static const char red[] = "#d57780";
static const char orange[] = "#caaa6a";
static const char yellow[] = "#EBCB8B";
static const char pink[] = "#e39a83";
static const char col_borderbar[] = "#81a1c1"; // inner border

static const char *colors[][3] = {
    /*               fg         bg         border   */
    [SchemeNorm] = {green, black, gray2},
    [SchemeSel] = {green, black, col_borderbar},
};

/* tagging */
static const char *tags[] = {"", "", "", "", "5", "6", "7"};

static const unsigned int ulinepad =
    5; /* horizontal padding between the underline and tag */
static const unsigned int ulinestroke =
    2; /* thickness / height of the underline */
static const unsigned int ulinevoffset =
    0; /* how far above the bottom of the bar the line should appear */
static const int ulineall =
    0; /* 1 to show underline on all tags, 0 for just the active ones */

static const Rule rules[] = {
    {"TelegramDesktop", NULL, NULL, 0, 1, 0, 0, -1},
    {"obs", NULL, NULL, 0, 1, 0, 0, -1},
    {"Lutris", NULL, NULL, 0, 1, 0, 0, -1},
    {"Brave", NULL, NULL, 0, 0, 0, 0, -1},
    {"Discord", NULL, NULL, 0, 0, 0, 0, -1},
    {"St", NULL, NULL, 0, 0, 1, 0, -1},

    {"Gimp", NULL, NULL, 0, 1, 0, 0, -1},
    {"Librewolf", NULL, NULL, 1 << 8, 0, 0, -1, -1},
    {"Alacritty", NULL, NULL, 0, 0, 1, 0, -1},
    {"st", NULL, NULL, 0, 0, 1, 0, -1},
    {NULL, NULL, "Event Tester", 0, 0, 0, 1, -1}, /* xev */
};

/* layout(s) */
static const float mfact = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;   /* number of clients in master area */
static const int resizehints =
    1; /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen =
    1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT                                                           \
  1 /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
    /* symbol     arrange function */
    {"[]=", tile}, /* first entry is default */
    {"[M]", monocle},
    {"[@]", spiral},
    {"[\\]", dwindle},
    {"H[]", deck},
    {"TTT", bstack},
    {"===", bstackhoriz},
    {"HHH", grid},
    {"###", nrowgrid},
    {"---", horizgrid},
    {":::", gaplessgrid},
    {"|M|", centeredmaster},
    {">M>", centeredfloatingmaster},
    {"><>", NULL}, /* no layout function means floating behavior */
    {NULL, NULL},
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \
      {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
  }

/* commands */
static char dmenumon[2] =
    "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
    "dmenu_run", "-m",      dmenumon, "-fn",    dmenufont, "-nb",     col_gray1,
    "-nf",       col_gray3, "-sb",    col_cyan, "-sf",     col_gray4, NULL};
static const char *termcmd[] = {
    "sh", "-c", "alacritty msg create-window || alacritty", NULL};
static const char *termcmd2[] = {"alacritty", NULL};
static const char *printscreencmd[] = {"flameshot", "gui", NULL};

static const Key keys[] = {
    /* modifier                     key        function        argument */
    //{MODKEY, XK_p, spawn, {.v = dmenucmd}},
    {MODKEY, XK_Return, spawn, {.v = termcmd}},
    {MODKEY, XK_space, spawn, {.v = termcmd2}},
    {MODKEY, XK_b, togglebar, {0}},
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY, XK_o, incnmaster, {.i = -1}},
    {MODKEY, XK_h, setmfact, {.f = -0.05}},
    {MODKEY, XK_l, setmfact, {.f = +0.05}},
    {MODKEY | ShiftMask, XK_k, setcfact, {.f = +0.25}},
    {MODKEY | ShiftMask, XK_j, setcfact, {.f = -0.25}},
    {MODKEY | ShiftMask, XK_o, setcfact, {.f = 0.00}},
    {MODKEY, XK_f, zoom, {0}},
    {MODKEY | Mod1Mask, XK_0, togglegaps, {0}},
    {MODKEY | Mod1Mask | ShiftMask, XK_0, defaultgaps, {0}},
    {MODKEY, XK_Tab, view, {0}},
    {MODKEY, XK_q, killclient, {0}},
    {MODKEY, XK_t, setlayout, {.v = &layouts[0]}},
    {MODKEY, XK_m, setlayout, {.v = &layouts[2]}},
    //{MODKEY, XK_space, setlayout, {0}},
    {MODKEY | ShiftMask, XK_space, togglefloating, {0}},
    {MODKEY, XK_0, view, {.ui = ~0}},
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
    {MODKEY, XK_comma, focusmon, {.i = -1}},
    {MODKEY, XK_period, focusmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},
    {0, XK_Print, spawn, {.v = printscreencmd}},
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5) TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7)
            TAGKEYS(XK_9, 8){MODKEY | ShiftMask, XK_q, quit, {0}},
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
 * ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function argument */
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};
