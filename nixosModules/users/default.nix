{ inputs
, pkgs
, meta
, ...
} @ args:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.mutableUsers = false;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit (args) inputs meta _passthru;
    };
  };

  users.users.iris = {
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "wheel" "systemd-journal" ];
    hashedPassword = "$y$j9T$z7JS6B0cpr3ygE6oILEiW0$InFvGn7wq71.9cwKa6QAkWUGB6/qC6MX8t.VKacpQA7";
  };

  home-manager.users.iris = (meta.homeConfigurations.iris args);
}
