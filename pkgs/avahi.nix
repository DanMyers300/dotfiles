{ ... }:
{
  ### --- Avahi (for UxPlay AirPlay server) --- ###
  ### --- Ports: TCP(7000 7001 7100) UDP: 5353 6000 6001 7011
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };
}
