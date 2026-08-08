{ ... }:
{
  hardware.uinput.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      output_name = "DP-2";
      adapter_name = "/dev/dri/renderD128";
    };
  };
}
