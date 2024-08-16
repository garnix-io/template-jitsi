{ pkgs, ... }:

# TODO: Change these variables to whatever works for you
let # This lets you log in via SSH
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIVpNqdbM7uE1xkKoXztoaAtKtDHoqHS3DrzxYKsDgxa jkarni@garnix.io";
    # This should be based on your repo. In particular, it should be:
    #    jitsi.<BRANCH>.<REPONAME>.<GITHUB ORG/USER>.garnix.me
    # It can also be a custom domain. In that case, set up a CNAME to the above
    # domain.
    host = "jitsi.main.template-jitsi.garnix-io.garnix.me";
in {
  # This sets up networking and filesystems in a way that works with garnix hosting
  garnix.server.enable = true;

  # This is so we can log in.
  #   - First we enable SSH
  services.openssh.enable = true;
  #   - Then we create a user called "me". You can change it if you like; just
  #     remember to use that user when ssh'ing into the machine.
  users.users.me = {
    # This lets NixOS know this is a "real" user rather than a system user,
    # giving you for example a home directory.
    isNormalUser = true;
    description = "me";
    extraGroups = [ "wheel" "systemd-journal" ];
    openssh.authorizedKeys.keys = [ sshKey ];
  };

  # This actually sets up jitsi
  services.jitsi-meet = {
    enable = true;
    hostName = host;
  };
  services.jitsi-videobridge.openFirewall = true;

  # By default the Jitsi module sets nginx up so that it does TLS certificate
  # generation. garnix expects to handle the TLS termination itself, so we
  # disable this.
  services.nginx.virtualHosts."${host}" = {
    # We'll handle SSL elsewhere
    enableACME = false;
    forceSSL = false;
  };

  # This specifies what packages are available in your system. You can choose
  # from over 100,000 - search for them here:
  #   https://search.nixos.org/options?channel=24.05
  environment.systemPackages = [
    pkgs.htop
  ];

  # We open these ports.
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # This is currently the only allowed value.
  nixpkgs.hostPlatform = "x86_64-linux";
}
