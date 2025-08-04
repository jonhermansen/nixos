{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_6_15;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.supportedFilesystems = [ "zfs" ];
  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
    brave
    cargo
    colmena
    curl
    dmenu
    emacs-nox
    fastfetch
    ghostty
    git
    i3
    i3blocks
    i3status
    i3-volume
    librewolf
    mangohud
    sway
    xorg.xdpyinfo
    zig
  ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = true;
  networking.hostId = "9461e5a3";
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  nixpkgs.config.allowUnfree = true;
  services.gnome.gnome-keyring.enable = true;
  services.openssh.enable = true;
  services.xserver = {
    displayManager.startx.enable = true;
    enable = true;
    screenSection = ''
    Option "Stereo" "0"
    Option "nvidiaXineramaInfoOrder" "DP-2"
    Option "metamodes" "1920x1080_144 +0+0 {AllowGSYNCCompatible=On}"
    Option "SLI" "Off"
    Option "MultiGPU" "Off"
    Option "BaseMosaic" "off"
    '';
    windowManager.i3.enable = true;
    videoDrivers = [ "nvidia" ];
  };
  system.stateVersion = "25.11";
  time.timeZone = "US/Eastern";
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "input" "video" "wheel" ];
  };
}
