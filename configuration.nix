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
  # environment.gnome.excludePackages = (with pkgs; [
  #   atomix # puzzle game
  #   cheese # webcam tool
  #   epiphany # web browser
  #   evince # document viewer
  #   geary # email reader
  #   gedit # text editor
  #   gnome-characters
  #   gnome-music
  #   gnome-photos
  #   gnome-terminal
  #   gnome-tour
  #   hitori # sudoku game
  #   iagno # go game
  #   tali # poker game
  #   totem # video player
  # ]);
  environment.sessionVariables.GTK_THEME = "Dracula";
  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
    (sudo.override { withInsults = true; })
    balatro
    brave
    cargo
    chatterino2
    cmake
    #code-cursor
    colmena
    curl
    discord
    dmenu
    dracula-icon-theme
    dracula-qt5-theme
    dracula-theme
    emacs-nox
    fastfetch
    gcc
    gh
    ghostty
    git
    #gnome.adwaita-icon-theme
    #gnome.gnome-settings-daemon
    #gnomeExtensions.appindicator
    gnumake
    i3
    i3blocks
    i3status
    i3-volume
    libpng
    librewolf
    llama-cpp
    mangohud
    mpv
    nix-update
    nixfmt
    nixpkgs-review
    ollama
    pavucontrol
    pipewire
    protonvpn-gui
    pulseaudio
    python3
    open-webui
    openvpn
    qpwgraph
    rustc
    sbctl
    scrot
    signal-desktop
    spirv-tools
    steam
    sway
    virt-manager
    virtualenv
    vscode
    waydroid
    windsurf
    wireguard-tools
    xorg.xdpyinfo
    zig
    zlib
    zls
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
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-compute-runtime
    # intel-media-sdk # DO NOT ENABLE, vulnerable!
    intel-vaapi-driver
    mesa
    nvidia-vaapi-driver
    vaapiIntel
    vaapiVdpau
    vpl-gpu-rt
    #vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
  ];  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  #networking.firewall.checkReversePath = false; # for protonvpn
  #networking.firewall.allowedTCPPorts = [ 22 ];
  #networking.firewall.enable = false;
  networking.hostId = "00000000";
  networking.hostName = "desktop";
#  networking.nameservers = [
#    "1.1.1.1#one.one.one.one"
#    "1.0.0.1#one.one.one.one"
#  ];
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.cudaSupport = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  nixpkgs.overlays = [
    (self: super: {
      # bork = super.stdenv.mkDerivation rec {
      #   name = "bork";
      #   version = "0.4.0";
      #   src = super.fetchFromGitHub {
      #     owner = "kristoff-it";
      #     repo = "bork";
      #     rev = "ae7c7a82fc717d31dd9240300e5ca84f069dc453";
      #     hash = "sha256-HAW5/FXgAwD+N48H+K2salN7o125i012GB1kB4CnXgQ=";
      #   };
      #   zigBuildFlags = [
      #     "--system"
      #   ];
      # };
#      code-cursor = super.code-cursor.override {
#        src = super.fetchurl {
#          url = "https://downloads.cursor.com/production/a1fa6fc7d2c2f520293aad84aaa38d091dee6fef/linux/x64/Cursor-1.3.8-x86_64.AppImage";
#          hash = "sha256-qR1Wu3H0JUCKIoUP/QFC1YyYiRaQ9PVN7ZT9TjHwn1k=";
#        };
#        #version = "1.3.8";
#        vscodeVersion = "1.99.3";
#        preInstall = null;
#      };
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
      # ghostty = super.ghostty.overrideAttrs (old: rec {
      #   src = super.fetchFromGitHub {
      #     owner = "ghostty-org";
      #     repo = "ghostty";
      #     rev = "eccff1ea95215bb0f551b2b8fcd4450323daa72c";
      #     hash = "sha256-qZcfWjb5RzZRcCKTIxBsdHnLoUVsZg6fKDUNMsYa1I4=";
      #   };
      #   deps = super.ghostty.deps.overrideAttrs (old2: rec {
      #     #name = "${old.pname}-cache-${old.version}";
      #     zig = pkgs.zig;
      #   });
      # });
    })
  ];
  programs.dconf.enable = true;
  programs.obs-studio.package = (pkgs.obs-studio.override {
    cudaSupport = true;
  });
  programs.steam.enable = true;
  programs.zsh.enable = true;
  security.polkit.enable = true;
  #services.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;
  #services.openssh.enable = true;
  # services.resolved = {
  #   enable = true;
  #   dnssec = "true";
  #   domains = [ "~." ];
  #   fallbackDns = [
  #     "1.1.1.1#one.one.one.one"
  #     "1.0.0.1#one.one.one.one"
  #   ];
  #   dnsovertls = "true";
  # };
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
      "audio"
      "disk"
      "input"
      "libvirtd"
      "networkmanager"
      "qemu-libvirtd"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
  # virtualisation.libvirtd = {
  #   enable = true;
  #   qemu = {
  #     package = pkgs.qemu_kvm;
  #     runAsRoot = true;
  #     swtpm.enable = true;
  #     ovmf = {
  #       enable = true;
  #       packages = [
  #         (pkgs.OVMF.override {
  #           secureBoot = true;
  #           tpmSupport = true;
  #         }).fd
  #       ];
  #     };
  #   };
  # };
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
#      verbatimConfig = ''
#    cgroup_device_acl = [
#        "/dev/null", "/dev/full", "/dev/zero",
#        "/dev/random", "/dev/urandom",
#        "/dev/ptmx", "/dev/kvm",
#        "/dev/kvmfr0"
#    ]
#'';
      vhostUserPackages = with pkgs; [ virtiofsd ];
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd # AAVMF
          (pkgs.OVMFFull.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
          #pkgsAarch64.OVMFFull.fd
        ];
      };
    };
  };
  virtualisation.waydroid.enable = true;
  virtualisation.xen.enable = false;
}
