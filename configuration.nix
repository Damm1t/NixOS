{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Unfree software permission  - for NVIDIA & Steam)
  nixpkgs.config.allowUnfree = true;

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Steam & Gaming setup
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamemode.enable = true;

  # NVIDIA Drivers & Hybrid Offloading 
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; 
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

    environment.systemPackages = with pkgs; [
    git
    treefmt
    nixpkgs-fmt
    pre-commit
    rustup
    gcc
    curl
    wget
    btop
    powertop
    pciutils
    lshw
    clang
    pkg-config
    openssl
    openssl.dev
    gnumake
    cmake
    jetbrains.idea

    python3
    python3Packages.pip
    python3Packages.tkinter
   
    mangohud
    bottles
    firefox
    google-chrome
    vscode
    protonup-qt
    lutris

   
    spotify
    telegram-desktop 
  ];

   users.users.zeta = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    initialPassword = "12345678";
 };
    networking.hostName = "dell-g15";
    system.stateVersion = "24.11";


   services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true ;
    services.xserver.desktopManager.gnome.enable = true ;
}
