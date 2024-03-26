let
  edean = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOoOK2BxZdNrWgli6jnYOdlgl6o8rjk7N9FDFo3rfU3m";
  users = [ edean ];
in
{
  "secure_profile.age".publicKeys = users;
  "id_rsa.age".publicKeys = users;
  "id_rsa.pub.age".publicKeys = users;
}
