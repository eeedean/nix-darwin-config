{ config, lib, pkgs, system, user, ... }:
  let
    homedir = if (lib.strings.hasSuffix "darwin" system) then "/Users/${user}" else "/home/${user}";
  in
  {
    age = {
      secrets = {
        secure_profile = {
          file = ../secrets/secure_profile.age;
          path = "${homedir}/.secure_profile";
        };
        id_rsa = {
          file = ../secrets/id_rsa.age;
        };
        id_rsa_pub = {
          file = ../secrets/id_rsa.pub.age;
        };
      };
      identityPaths = [ "${homedir}/.ssh/id_ed25519" ];
    };
}
