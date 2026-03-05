{ ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.1";
    host = "0.0.0.0";
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.1";
    };
  };
  nixpkgs.config.rocmSupport = true;
}
