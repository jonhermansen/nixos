{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_15;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.supportedFilesystems = [ "zfs" ];
  environment.sessionVariables.GTK_THEME = "Dracula";
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
    dracula-icon-theme
    dracula-qt5-theme
    dracula-theme
    emacs-nox
    fastfetch
    ghostty
    git
    i3
    i3blocks
    i3status
    i3-volume
    librewolf
    llama-cpp
    mangohud
    nixfmt
    ollama
    open-webui
    rustc
    sbctl
    scrot
    sway
    xorg.xdpyinfo
    zig
  ];
  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "JetBrains Mono" ];
      sansSerif = [ "JetBrains Mono" ];
      monospace = [ "JetBrains Mono" ];
    };
  };
  fonts.packages = with pkgs; [
    jetbrains-mono
    liberation_ttf
    noto-fonts
    source-code-pro
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
  networking.hostId = "00000000";
  networking.hostName = "desktop";
  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      colmena = super.colmena.overrideAttrs (old: rec {
        cargoDeps = self.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-v5vv66x+QiDhSa3iJ3Kf7PC8ZmK1GG8QdVD2a1L0r6M=";
        };
        patches = [ ];
        src = super.fetchFromGitHub {
          owner = "zhaofengli";
          repo = "colmena";
          rev = "5e0fbc4dbc50b3a38ecdbcb8d0a5bbe12e3f9a72";
          hash = "sha256-vwu354kJ2fjK1StYmsi/M2vGQ2s72m+t9pIPHImt1Xw=";
        };
      });
    })
  ];
  programs.zsh.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.openssh.enable = true;
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    dnsovertls = "true";
  };
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
    extraGroups = [
      "input"
      "libvirtd"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };
  virtualisation.xen.enable = false;
}
