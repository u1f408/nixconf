{ meta, inputs, ... }:

{
  imports = with meta; [
    users.iris.guiFull
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "iris";
    startMenuLaunchers = true;
  };
}
