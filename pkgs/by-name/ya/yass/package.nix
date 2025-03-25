{
  lib,
  stdenv,
  openjdk8,
  ant,
  makeWrapper,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "yass";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "SarutaSan72";
    repo = "Yass";
    rev = "${finalAttrs.version}";
    hash = "sha256-eZomMlc8MRqekzRCTOxeN3gaxMmxQK2W61CTlKpUj6g=";
  };

  nativeBuildInputs = [
    openjdk8
    makeWrapper
  ];

  buildInputs = [
    ant
  ];

  buildPhase = ''
    runHook preBuild

    export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
    ant -f build-jar.xml compile jar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${finalAttrs.pname}

    cp release/${finalAttrs.pname}-${finalAttrs.version}.jar $out/share/${finalAttrs.pname}

    makeWrapper ${lib.getExe openjdk8} $out/bin/${finalAttrs.pname} \
      --add-flags "-cp $out/share/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.jar yass.YassMain"

    runHook postInstall
  '';

  meta = {
    description = "Karaoke Editor for finetuning Ultrastar Songs";
    homepage = "http://yass-along.com/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ _0x5a4 ];
  };
})
