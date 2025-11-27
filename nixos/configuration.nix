# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lobo"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.networkmanager.dns = "default";

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Thunar
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # Layout do teclado no sistema todo (tty + X/Wayland)
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "intl";
    # opcional, se quiser CapsLock => Escape:
    # xkb.options = "caps:escape";
  };

  # Faz o console (tty) usar a mesma config de teclado
  console = {
    useXkbConfig = true;
    # NÃO definir console.keyMap aqui pra não dar conflito
  };

  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # XDG portals para sway + wayland
  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.sway.default = lib.mkForce "wlr";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = lib.mkForce true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # new filesystem
  fileSystems."/mnt/games" = {
    device = "/dev/sda2";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lobo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  # ================================
  # Ambiente global Elixir / Phoenix
  # ================================
  environment.systemPackages = with pkgs; [
    vim
    emacs
    wget
    fuzzel
    firefox
    alacritty
    neofetch
    grim
    slurp
    wl-clipboard
    mako
    pavucontrol
    alsa-utils
    gimp
    blender
    audacity
    git
    gcc
    xfce.thunar
    xfce.thunar-archive-plugin
    file-roller
    xfce.thunar-volman
    p7zip
    unzip
    wf-recorder
    ffmpeg
    mangohud
    gamemode
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    zoom-us
    yazi
    (yazi.override {
      _7zz = _7zz-rar;
    })

    # --- Elixir / Phoenix dev ---
    elixir
    elixir_ls
    erlang
    nodejs_24
    yarn
    
    # libs de build / utilitários
    gnumake
    openssl
    zlib
    libxml2
    curl
    libiconv

    # llm
    lmstudio
    ];

  # Variáveis de ambiente para mix/hex e Erlang
  environment.variables = {
    MIX_HOME   = "/home/lobo/.nix-mix";
    HEX_HOME   = "/home/lobo/.nix-hex";

    LANG       = "en_US.UTF-8";
    ERL_AFLAGS = "-kernel shell_history enabled";
    ERL_LIBS   = "/home/lobo/.nix-hex/lib/erlang/lib";
  };

  # Criar diretórios do mix/hex para o usuário lobo
  system.activationScripts.elixirDirs = {
    text = ''
      HOME="/home/lobo"
      mkdir -p "$HOME/.nix-mix" "$HOME/.nix-hex"
      chown -R lobo:users "$HOME/.nix-mix" "$HOME/.nix-hex" || true
    '';
  };


  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.hack
    nerd-fonts.ubuntu
    # nerd-fonts.mplu 
    nerd-fonts.symbols-only
    nerd-fonts.hurmit
    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono
  ];
  # yazi
  programs.yazi.enable = true;

  # Steam + Proton
  hardware.graphics.enable = true;
  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Gamemode daemon
  programs.gamemode.enable = true;

  networking.firewall.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}