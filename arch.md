# Arch Linux Install
If you use Windows and want to install dual system, please close bitlocker, secure boot, fast startup and hibernation.

Check disk manager if the disk have bitlocker, if have, disable it, how to do please google.

Disable secure boot in BIOS.

In Windows PowerShell (Admins), type `powercfg -h off` and Enter to disable fast startup and hibernation.

```
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
```
Above command use to set time for windows and arch

### 1. Setfont
```
setfont ter-122b
setfont ter-124b 
setfont ter-128b
setfont ter-132b
```
### 2. UEFI or BIOS
```
cat /sys/firmware/efi/fw_platform_size
64      // 64 bit UEFI
32      // 32 bit UEFI, but only can boot by grub
none    // BIOS

or

ls /sys/firmware/efi/efivars
ls: cannot access '/sys/firmware/efi/efivars': No such file or directory    // BIOS
a series of message     // EFI

or

fdisk -l
Disklabel type: gpt
and have EFI System partition
it's UEFI, otherwise BIOS
```

### 3. Network
```
iwctl           // run iwctl program
device list     // remember your Devices Name, such as wlan0
station wlan0 scan          // scan and print networks
station wlan0 get-networks  
station wlan0 connect "Network name"
then input the password
quit                // quit iwctl
ping archlinux.org  // test network

or

use USB network share
```

### 4. Update System Time
```
timedatectl     // it should be slow 8 hours
```

### 5. Disk Partition
```
fdisk -l        // select which disk you want to installed, such as /dev/sda
fdisk /dev/sda  // select disk

p               // print present partition

g               // create GPT disklabel if you install in a new disk
                // if you install dual system, this step and next step (create efi) can skip
                // if you use BIOS, type o instead of p to create MBR disklabel
                // and BIOS don't need the boot parition so skip next steo (create efi)

n               // create efi partition
Enter           // default partition number
Enter           // default first sector
+512M           // 512Mb for efi
t               // change type of partition
1               // type change to EFI System

n               // create root partition
Enter           // default partition number
Enter           // default first sector
Enter           // default last sector

t               // change type of partition
Enter or other  // select the parition above you create
23              // type change to Linux root (x86_64)
                // if use other architecture, type L to find which you need
                // if BIOS, type 83 for linux

p               // check partition, if have mistake, type q quit and operate again

w               // write partition
```

### 6. Select File System
Linux file system have so many, such as ext4, btrfs, xfs, etc.

/dev/sda1 and /dev/sda2 should be your efi system and root separately.

If dual system, efi system is not need.

```
mkfs.fat -F 32 /dev/sda1    // format /dev/sda1 to fat file system
mkfs.ext4 /dev/sda2         // format /dev/sda2 to ext4 file System
```

### 7. mount partition
First should mount root partition
```
mount /dev/sda2 /mnt    // mount root partition

mount --mkdir /dev/sda1 /mnt/boot   // create /mnt/boot directory and mount efi partition to it
```
If dual system, the second command should be
```
mount --mkdir /dev/sda1 /mnt/efi
```

### 8. Swapfile
this size should be your memory size, such as 8G
```
dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192 status=progress
chmod 0600 /mnt/swapfile
mkswap -U clear /mnt/swapfile
swapon /mnt/swapfile
```

### 9. Change Source
```
reflector --list-countries  // select countrie where are you, such as China

reflector -p https -c China --delay 3 --completion-percent 95 --sort rate --save /etc/pacman.d/mirrorlist

or  // if above error

reflector -p https -c China --delay 3 --completion-percent 95 --sort score --save /etc/pacman.d/mirrorlist
```

### 9. Install Package
base is use for basic package  
linux kernel have linux, linux-lts, linux-zen, linux-hardened  
linux-firmware is linux firmware  
```
pacstrap -K /mnt base linux linux-firmware
```
if have error try follow commands and try install above again
```
pacman-key --init
pacman-key --populate
pacman -Sy archlinux-keyring
```

### 10. Fstab
```
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab                // for check
```

### 11. Chroot
```
arch-chroot /mnt
```

### 12. Localtime
/usr/share/zoneinfo/ then tab to find where you are, such as Shanghai 
```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
```

### 13. Set Locale and terminus-font
```
pacman -S neovim terminus-font          // or other tools which you like, such as vi, vim, nano, etc.
nvim /etc/locale.gen
delete / for en_US.UTF-8 UTF-8 and other locale you need, such as zh_CN.UTF-8 UTF-8

locale-gen
nvim /etc/locale.conf
LANG=en_US.UTF-8

nvim /etc/vconsole.conf
FONT=ter-132b           // or other
```

### 14. Configure Network
Set hostname, such as arch
```
nvim /etc/hostname
arch
```
hostname can reference this https://www.rfc-editor.org/rfc/rfc1178 
```
nvim /etc/hosts
127.0.0.1	localhost
::1       localhost
127.0.1.1	arch.localdomain	arch
```
Set network
```
pacman -S networkmanager        // or other you like
systemctl enable NetworkManager.service
```

### 15. Root Password
```
passwd
then input your root password
```

### 16. Lead Boot program
```
cat /proc/cpuinfo | grep "model name"   // check your computer cpu type
pacman -S intel-ucode   // if intel
pacman -S amd-ucode     // if amd
```
If use BIOS
```
pacman -S grub
grub-install --target=i386-pc /dev/sda  // /dev/sda is your install disk
grub-mkconfig -o /boot/grub/grub.cfg
```
If use EFI
```
pacman -S grub efibootmgr   // dual system need to install os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
                            // for dual system, /boot should be /efi

// for dual system, need follow commands
nvim /etc/default/grub
delete # for GRUB_DISABLE_OS_PROBER=false

grub-mkconfig -o /boot/grub/grub.cfg
```
> If windows boot entry not had in grub, you need type 'os-prober' and grub-mkconfig again after you finish install arch and reboot it.
### 17. Reboot
```
exit
swapoff /mnt/swapfile
umount -R /mnt
reboot
```

## Other
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
sudo pacman -Rs package // uninstall package
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
sudo pacman -S base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si 
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
install noto-fonts-cjk for Chinese font

install fcitx and fcitx-im

install a Chinese supply package, reference https://wiki.archlinux.org/index.php/fcitx#Chinese
```
sudo nvim /etc/profile
add this at the beginning
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
```
### 9. Audio
```
sudo pacman -S alsa-utils sof-firmware alsa-firmware
```
