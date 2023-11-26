# suckless
```
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu
git clone https://git.suckless.org/slstatus

sudo pacman -S xorg
cd dwm
sudo make clean install
cd ../st
sudo make clean install
cd ../dmenu
sudo make clean install
cd ../slstatus
sudo make clean install

sudo pacman -S xorg-init
cp /etc/X11/xinit/xinitrc ~/.xinitrc

nvim .xinitrc
delete five rows in the end of this file (begin twm & to exec xterm ...)
add follow line to the end of this file, then save and quit
exec dwm

startx
// if can't starx, please type exit command some times until back to login, and login your user then try again

Alt + Shift + Enter // open the st
// if the font size is too small, try Ctrl + Shift + PgUp
// if not useful, try to change the font size in st's config.h then sudo make clean install again
// edit config.h need sudo

Alt + Shift + c     // close st

// if the windows not full your screen, try follow
xrandr -q
in the ouput result
your screen name usually in second row's first word, such as screenName connected ...
xrandr --output screenName --mode 1920x1080 --rate 60.00   // other mode or rate you can choose
add above to .xinitr before exec dwm

Ctrl + q  // exit dwm
```
## st 
```
cd st
sudo nvim config.h
change font and size you like
such as
Source Code Pro:pixelsize=30
sudo pacman -S adobe-source-code-pro-fonts
sudo make clean install
```
## dwm
```
cd dwm
sudo nvim config.h
change fonts and dmenufont you like
such as
Source Code Pro:size=20
sudo make clean install

sudo pacman -S firefox noto-fonts-cjk   // for Chinese
Ctrl + p        // open dmenu and search firefox to open

Alt + t         // change the windows mode
Alt + f
Alt + m

Alt + h         // change the size of window
Alt + l
Alt + j
Alt + k         // change focus on window

Alt + 123456789 // change to different tag
Alt + Shit + 123456789  // move window to different tag
```
### feh
```
sudo pacman -S feh
nvim .fehbg

#!/bin/sh
while true; do
    feh --no-fehbg --bg-fill --randomize ~/Pictures/*
    sleep 5m
done

chmod +x .fehbg

~/Pictures/* is your wallpaper's put place 

nvim .xinitrc
add follow before exec dwm and after xrandr
~/.fehbg &
```
### picom
```
sudo pacman -S picom

cd st
```
How to use git to path
```
git log     // check commit log
// use git to patch
make clean && rm -f config.h && git reset --hard origin/master
// the second step is to clear the config if you changed
// the thrid step is copy the newest origin master for official to here
// if you want to save your config, the two steps above don't exec

git config user.name yourname       // log your account
git config user.email "youremail"

git branch              // check branch
git branch config       // create new branch config
git checkout config     // switch to config branch

// if you want to save you config, exec this step
cp config.h config.def.h
sudo nvim config.def.h          // patch
git add config.def.h            // add and commit
git commit -m config

git checkout master         // switch to master
git merge config -m config  // merge

sudo make clean install     // install
```
For example, set font
```
git branch font
git checkout font
sudo nvim config.def.h      // change font
git add config.def.h
git commit -m font
git checkout master
git merge font -m font
sudo make clean install
```
picom
```
make clean && rm -f config.h
git branch picom
git checkout picom
use wget to download picom patch on suckless.org
patch -p1 -F 0  < pathname
git add which files the path change
git commit -m picom
git checkout master
git merge picom -m picom
git merge font -m font      // this step is not use, because master already have font patch
sudo make clean install

cp /etc/xdg/picom.conf ~/.config/picom.conf
nvim ~/.config/picom.conf
change as follow

corner-radius = 20
add follow to rounded-corners-exclude
"x = 0 && y = 0 && override_redirect = true",
"class_g = 'firefox' && argb",

blur-method = "dual_kawase"
blur-strength = 5
blur-background = true
backend = "glx"

// if you use virtualmachine maybe need follow
# vsync = true

add follow before exec dwm to .xinitrc
picom &
```
add follow patches to st
```
anysize
dracula
hidecursor
scrollback
```
if patch have failed  
to check .rej file and fix the problem

### kdiff3
```
// use kdiff3 to solve branch conflict
sudo pacman -S kdiff3
// or use vimdiff

git config --global merge.tool kdiff3
```
## dwm
patches
```
alpha
awesomebar
fullscreen
hide-vacant_tags
noborder
pertag
rotatestack
scratchpad
vanitygaps
viewontag

download all of above patches
make clean && rm -d config.h && git reset --hard origin/master

you can make a branch config for font or other

git branch patch1
git checkout patch1
patch < patch1
if failed to fix it
git add the changed files
git commit -m patch1
git checkout master
todo other patches

git merge patch1 -m patch1
todo other patches
if conflict do follow
git mergetool
git commit -m fixconflict

sudo make clean install

cp config.h config.def.h    // if you chnage config.h and want to save it
make clean && rm -f config.h
git checkout config
sudo nvim config.def.h
change context as follow

borderpx = 2
gappih = 10
gappov = 10
smartgaps = 1

git add config.def.h
git commit -m config
git checkout master
git merge config -m config
if have conflict fix it
sudo make clean install
```

## slstatus
```
add follow before exec dwm in .xinitrc
exec slstatus &

	{ battery_perc,	"Charge%s%% ] ",	"BAT1" },
other config you can set
```

### backlight
```
sudo pacman -S acpilight
sudo chmod a+w /sys/class/backlight/intel or amd/brightness
sudo chmod a+w /sys/class/backlight/intel or amd/max_brightness  // possibly not required
// above way only can effect once until reboot

you need to add your user to group video
groups username // checkout username's groups, if not have group video, add it
sudo gpasswd -a username video
then log out and log user again

// add to slstatus
	{ run_command,	"Light%s%% ",		"xbacklight -get" },
// add to dwm 
static const char *lightup[] = { "xbacklight", "-inc", "2", NULL };
static const char *lightdown[] = { "xbacklight", "-dec", "2", NULL };
	{ MODKEY,                       XF86XK_MonBrightnessUp,       spawn,          {.v = lightup } },
	{ MODKEY,                       XF86XK_MonBrightnessDown,     spawn,          {.v = lightdown } },

you can see your own keymap by xev, xmodmap -pm, xmodmap -pke, <X11/XF86keysym.h>
```
### amixer
```
sudo pacman -S alsa-utils sof-firmware alsa-firmware
the last two packages maybe need if you need the firmware supply

cat /proc/asound/cards
to find which card's have 98, such as 2
sudo nvim /usr/share/alsa/alsa.conf
change as follow
defaults.ctl.card 2
defaults.pcm.card 2

speaker-test -c2 to find double playback
if amixer Master only mono playback
try pulseaduio tools, such as pavucontrol/pactl
install pulseaduio-alsa
then reboot
to check amixer sget Master 

//add to slstatus
	{ run_command,	"[ Volume%s ",		"amixer sget Master | awk -F \"[][]\" ' /Left:/ { print $2 }'" },
// add to dwm
static const char *volumeup[] = { "amixer", "sset", "Master", "5%+", "unmute", NULL };
static const char *volumedown[] = { "amixer", "sset", "Master", "5%-", "unmute", NULL };
static const char *volumetoggle[] = { "amixer", "sset", "Master", "toggle", NULL };
	{ MODKEY,                       XF86XK_AudioRaiseVolume,      spawn,          {.v = volumeup } },
	{ MODKEY,                       XF86XK_AudioLowerVolume,      spawn,          {.v = volumedown } },
	{ MODKEY,                       XF86XK_AudioMute,     	      spawn,          {.v = volumetoggle } },
```
### status
You can use your custom status bar to replace the slstatus, such as
```
#!/bin/bash
while true; do
  VOLUME=$(amixer get Master | awk -F'[][]' 'END{ print $2":"$4 }')
  if [[ $VOLUME =~ "on" ]]; then
    VOLUME=$(echo "$VOLUME" | awk -F : '{ print $1 }')
  else
    VOLUME="Mute"
  fi

  BATTERY=$(cat /sys/class/power_supply/BAT1/capacity)

  LIGHT=$(xbacklight -get)

  TIME=$(date)
  HOURS=${TIME:(-20):2}
  if [[ $TIME =~ "PM" ]]; then
    if [[ $HOURS =~ "12" ]]; then
      HOURS=12
    else
      HOURS=$((HOURS+12))
    fi
  fi
  MINUTES=${TIME:(-17):2}
  TIME=$HOURS:$MINUTES

  xsetroot -name "$(printf "[ Volume%4s Light%3s%% Battery%3s%% ] %s " $VOLUME $LIGHT $BATTERY $TIME)"
  sleep 0.01
donebattery
```
