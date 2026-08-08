{ ... }:
{
  hardware.uinput.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      adapter_name = "/dev/dri/renderD128";
    };
  };
}
