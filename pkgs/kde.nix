{ ... }:
{
  services.desktopManager.plasma6.enable = true;

  services.displayManager = {
    plasma-login-manager.enable = true;
    #autoLogin.user = "dan"; # Replace with the desired user
  }
;}
