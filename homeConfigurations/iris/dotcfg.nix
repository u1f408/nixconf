{ inputs
, lib
, ...
}:

with lib;
with builtins;

let
  pathMapElements =
    (map
      (splitString " ")
      (filter (el: el != "")
        (splitString "\n" (readFile (inputs.iris-dotcfg + "/pathmap")))));

  isExecutable = mode: elem (substring 1 1 mode) ["7" "5"];

  elementInto =
    el: (nameValuePair (elemAt el 1) {
      source = inputs.iris-dotcfg + "/${elemAt el 0}";
      executable = isExecutable (elemAt el 2);
    });

in
{
  home.file = listToAttrs (map elementInto pathMapElements);
}
