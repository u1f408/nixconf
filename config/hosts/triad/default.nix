{ meta, inputs, ... }:

{
  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "iris";
    startMenuLaunchers = true;
  };
}
