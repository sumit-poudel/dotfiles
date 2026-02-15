# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs,... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
    boot.loader = {
    systemd-boot.enable = false;
    grub.enable = true;
    grub.device = "nodev";
    grub.theme = pkgs.fetchFromGitHub {
      owner = "shvchk";
      repo = "fallout-grub-theme";
      rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
      sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
    };
    grub.efiSupport = true;
    grub.useOSProber = true;
    efi.canTouchEfiVariables = true;
  };

  # Enable Xdg Portals for screen sharing and file picking
xdg.portal = {
  enable = true;
  config.common.default = "*";
  extraPortals = [ pkgs.xdg-desktop-portal-gnome ]; # Or wlr
};

# Important for NVIDIA + Wayland
boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;


  networking.hostName = "victuu"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  # Set your time zone.
  time.timeZone = "Asia/Kathmandu";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sumit = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "sumit poudel";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.shells = [ pkgs.zsh ];    
  environment.systemPackages = with pkgs; [
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   curl
   niri
   fastfetch
   btop
   nvtopPackages.full
   inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
   nvidia-vaapi-driver
   xwayland-satellite
   nvidia-modprobe
   vulkan-loader
   vulkan-tools
   alacritty
   kitty
   git
   firefox
   vscode
   zed-editor
  ];

  fonts.packages = with pkgs; [
  nerd-fonts.fira-code
  nerd-fonts.droid-sans-mono
  ];   

  programs = {
    nix-ld.enable = true;
    niri.enable = true;
    fish.enable = true;
    zsh.enable = true;
    xwayland.enable = true;

    steam = {
      enable = true;
    };
  };
 
hardware.graphics={
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
    nvidia-vaapi-driver # Bridges NVIDIA to the Browser
    libva-vdpau-driver
    libvdpau-va-gl
  ];
};
hardware.bluetooth.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
	offload = {
	  enable = true;
	  enableOffloadCmd = true;
	  };
	amdgpuBusId = "PCI:6:0:0";
	nvidiaBusId = "PCI:1:0:0";
	  };
  }; 
  hardware.nvidia-container-toolkit.enable = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services={
	xserver.videoDrivers =[
	"nvidia"
	];
	upower.enable = true;
	tuned.enable = true;
	openssh.enable = true;
	displayManager.ly = {
		enable = true;
	};
};

environment.variables = {
    XDG_SESSION_TYPE = "wayland";
    NVD_BACKEND = "direct";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    #__GLX_VENDOR_LIBRARY_NAME = "mesa";
    NIXOS_OZONE_WL = "1";
    # These two are vital for NVIDIA stability on Wayland
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GL_GSYNC_ALLOWED = "0"; # Often helps with flickering
    __GL_VRR_ALLOWED = "0";
    WLR_NO_HARDWARE_CURSORS = "1";
};
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
