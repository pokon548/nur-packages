{ lib, stdenv, callPackage, fetchurl, nixosTests, commandLineArgs ? ""
, useVSCodeRipgrep ? stdenv.isDarwin }:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = { x86_64-linux = "amd64"; }.${system} or throwSystem;

  archive_fmt = "zip";

  sha256 = {
    x86_64-linux = "1sfy6rcrayx661m96pyh96caycf6banjs5ksib48qsl6hxp76ks0";
  }.${system} or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in callPackage ./generic.nix rec {
  inherit sourceRoot commandLineArgs useVSCodeRipgrep;

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.0";
  pname = "chengla-electron";

  executableName = "chengla-linux-unofficial";
  longName = "Chengla Linux Unofficial";
  shortName = "chengla-linux-unofficial";

  src = fetchurl {
    url =
      "https://github.com/pokon548/chengla-for-linux/releases/download/${version}/chengla-linux-unofficial-${plat}-${version}.${archive_fmt}";
    inherit sha256;
  };

  meta = with lib; {
    description = ''
      Unofficial Chengla Client for Linux
    '';
    longDescription = ''
      Unofficial Chengla Client for Linux, built on Electron
    '';
    homepage = "https://github.com/pokon548/chengla-for-linux";
    downloadPage = "https://github.com/pokon548/chengla-for-linux/releases";
    license = licenses.gpl3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "chengla-linux-unofficial";
    platforms = [ "x86_64-linux" ];
  };
}
