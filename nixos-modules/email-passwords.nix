{ flakeRoot, ... }:
let
  nukdokplex-perms = {
    mode = "400";
    owner = "nukdokplex";
    group = "users";
  };
  generateEmailPasswordSecret = name: attrs: {
    ${name} = {
      rekeyFile = flakeRoot + /secrets/generated/common/${name}.age;
    } // attrs;
  };
in
{
  age.secrets =
    { }
    // (generateEmailPasswordSecret "nukdokplex-ru-has-nukdokplex-password" nukdokplex-perms)
    // (generateEmailPasswordSecret "gmail-com-has-nukdokplex-password" nukdokplex-perms)
    // (generateEmailPasswordSecret "gmail-com-has-vik-titoff2014-password" nukdokplex-perms)
    // (generateEmailPasswordSecret "outlook-com-has-nukdokplex-password" nukdokplex-perms)
    // (generateEmailPasswordSecret "yandex-ru-has-vik-titoff2014-password" nukdokplex-perms);
}
