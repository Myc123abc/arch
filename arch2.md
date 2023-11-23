### 1. Network
```
nmcli device wifi
nmcli device wifi connect 'name' password 'password'
```
### 2. User
```
useradd -m -G wheel username
passwd username

pacman -S sudo
EDITOR=nvim visudo
delete # for %wheel ALL=(ALL:ALL) ALL

su - username   // change to user
su -            // change to root
```
### 3. Pacman
```
sudo pacman -Syu        // update all package
sudo pacman -S package  // install package
sudo pacman -R package  // uninstall single package
sudo pacman -Rs package // uninstall package and its rependencies
```
### 4. TLP
```
sudo pacman -S tlp
systemctl enable --now tlp.service
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket
```
### 5. GPU
```
cat /proc/cpuinfo | grep "model name"

// for intel
sudo pacman -S mesa vulkan-intel intel-media-driver

// for amd
sudo pacman -S mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver
```
### 6. AUR
```
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
if makepkg failed, maybe network error (timeout), in China you can change go proxy
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
or
echo "export GO111MODULE=on" >> ~/.profile
echo "export GOPROXY=https://goproxy.cn" >> ~/.profile
source ~/.profile
```
### 7. Shadowsocks
```
sudo pacman -S shadowsocks   // or other implementations

nvim /etc/example.json
{
    "server":"my_server_ip",
    "server_port":8388,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"mypassword",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
}

// start with system service
sudo systemctl start shadowsocks@example.service
// boot machine auto start
sudo systemctl enable shadowsocks@example.service
```
#### Chrome Proxy
```
sudo pacman -S chromium
or
yay -S google-chrome

// command line proxy enable
google-chrome-stable --proxy-server="socks5://127.0.0.1:1080"
chromium instead of command is OK
then install SwitchyOmega plugin
configure GFWList and proxy rule then can auto proxy
```
#### Command Line Proxy
```
install proxychains-ng
sudo nvim /etc/proxychains.conf
find ProxyList entry in the end of this file
then add
socks5  127.0.0.1 1080

after when you need run command need proxy
just add proxychains at first, such as proxychains ping www.google.com
```
### 8. Input Method
```
sudo pacman -S fcitx5-im
edit ~/.bashrc and add follow, then login in again
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```
