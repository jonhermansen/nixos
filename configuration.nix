{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_6_15;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  environment.systemPackages = with pkgs; [
    colmena
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
    sway
    xorg.xdpyinfo
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
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  nixpkgs.config.allowUnfree = true;
  services.gnome.gnome-keyring.enable = true;
  services.openssh.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  system.stateVersion = "25.11";
  time.timeZone = "US/Eastern";
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "input" "video" "wheel" ];
  };
}

