{ config, lib, pkgs, user, ... }:
{
  age = {
    secrets = {
      secure_profile = {
        file = ../secrets/secure_profile.age;
        path = "/Users/${user}/.secure_profile";
      };
      id_rsa = {
        file = ../secrets/id_rsa.age;
        path = "/Users/${user}/.ssh/id_rsa";
      };
      id_rsa_pub = {
        file = ../secrets/id_rsa.pub.age;
        path = "/Users/${user}/.ssh/id_rsa.pub";
      };
    };
    identityPaths = [ "/Users/${user}/.ssh/id_ed25519" ];
  };
}
