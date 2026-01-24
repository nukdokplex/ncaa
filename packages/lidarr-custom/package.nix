{
  lib,
  stdenvNoCC,
  fetchYarnDeps,
  fetchFromGitHub,
  buildDotnetModule,
  nixosTests,
  nodejs,
  yarn,
  sqlite,

  dotnetCorePackages,

  applyPatches,
  prefetch-yarn-deps,
  fixup-yarn-lock,
  breakpointHook,
}:
let
  version = "3.1.2";
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "Lidarr";
      repo = "Lidarr";
      rev = "f6a3e7370540cc25caf3aaf0f1c91e7c085585ac";
      hash = "sha256-vjLoMU7Ow9rFFcZjCUvqoKZnrmg3TeB8Cqh1nSF8shM=";
    };
    postPatch = ''
      mv src/NuGet.config NuGet.config
    '';
  };
in
buildDotnetModule rec {
  pname = "lidarr";
  inherit version src;

  strictDeps = true;
  nativeBuildInputs = [
    nodejs
    yarn
    prefetch-yarn-deps
    fixup-yarn-lock
    breakpointHook
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-Jq2O7gvB+PKcz6uDBMg7ox6/Bu+pikXH6JGuLfKG5fI=";
  };

  postConfigure = ''
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs --build node_modules
  '';
  postBuild = ''
    yarn --offline run build --env production
  '';
  postInstall = ''
    cp -a -- _output/UI "$out/lib/lidarr/UI"
  '';

  nugetDeps = ./deps.json;

  runtimeDeps = [ sqlite ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  doCheck = true;

  __structuredAttrs = true; # for Copyright property that contains spaces

  executables = [ "Lidarr" ];

  projectFile = [
    "src/NzbDrone.Console/Lidarr.Console.csproj"
    "src/NzbDrone.Mono/Lidarr.Mono.csproj"
  ];

  testProjectFile = [
    "src/NzbDrone.Api.Test/Lidarr.Api.Test.csproj"
    "src/NzbDrone.Common.Test/Lidarr.Common.Test.csproj"
    "src/NzbDrone.Core.Test/Lidarr.Core.Test.csproj"
    "src/NzbDrone.Host.Test/Lidarr.Host.Test.csproj"
    "src/NzbDrone.Libraries.Test/Lidarr.Libraries.Test.csproj"
    "src/NzbDrone.Mono.Test/Lidarr.Mono.Test.csproj"
    "src/NzbDrone.Test.Common/Lidarr.Test.Common.csproj"
  ];

  dotnetFlags = [
    "--property:TargetFramework=net8.0"
    "--property:EnableAnalyzers=false"
    "--property:SentryUploadSymbols=false" # Fix Sentry upload failed warnings
    # Override defaults in src/Directory.Build.props that use current time.
    "--property:Copyright=Copyright 2014-2025 lidarr.audio (GNU General Public v3)"
    "--property:AssemblyVersion=${version}"
    "--property:AssemblyConfiguration=main"
    "--property:RuntimeIdentifier=${dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system}"
  ];

  testFilters = [
    "TestCategory!=ManualTest"
    "TestCategory!=IntegrationTest"
    "TestCategory!=AutomationTest"

    # makes real HTTP requests
    "FullyQualifiedName!~NzbDrone.Core.Test.UpdateTests.UpdatePackageProviderFixture"
  ];

  disabledTests = [
    # setgid tests
    "NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_preserve_setgid_on_set_folder_permissions"
    "NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_clear_setgid_on_set_folder_permissions"

    # we do not set application data directory during tests (i.e. XDG data directory)
    "NzbDrone.Mono.Test.DiskProviderTests.FreeSpaceFixture.should_return_free_disk_space"
    "NzbDrone.Common.Test.ServiceFactoryFixture.event_handlers_should_be_unique"

    # attempts to read /etc/*release and fails since it does not exist
    "NzbDrone.Mono.Test.EnvironmentInfo.ReleaseFileVersionAdapterFixture.should_get_version_info"

    # fails to start test dummy because it cannot locate .NET runtime for some reason
    "NzbDrone.Common.Test.ProcessProviderFixture.should_be_able_to_start_process"
    "NzbDrone.Common.Test.ProcessProviderFixture.exists_should_find_running_process"
    "NzbDrone.Common.Test.ProcessProviderFixture.kill_all_should_kill_all_process_with_name"

    # makes internet requests to spotify servers
    "NzbDrone.Core.Test.ImportListTests.SpotifyMappingFixture.map_album_should_work"
    "NzbDrone.Core.Test.ImportListTests.SpotifyMappingFixture.map_artist_should_work"

    # makes internet request to lidarr servers
    "NzbDrone.Core.Test.MetadataSource.SkyHook.SkyHookProxyFixture.getting_details_of_invalid_album"
    "NzbDrone.Core.Test.MetadataSource.SkyHook.SkyHookProxyFixture.getting_details_of_invalid_artist"
    "NzbDrone.Core.Test.MetadataSource.SkyHook.SkyHookProxyFixture.getting_details_of_invalid_guid_for_album"
    "NzbDrone.Core.Test.MetadataSource.SkyHook.SkyHookProxyFixture.getting_details_of_invalid_guid_for_artist"
    "NzbDrone.Core.Test.MetadataSource.SkyHook.SkyHookProxyFixture.should_be_able_to_get_album_detail"
    "NzbDrone.Core.Test.MetadataSource.SkyHook.SkyHookProxyFixture.should_be_able_to_get_album_detail_with_release"
    "NzbDrone.Core.Test.MetadataSource.SkyHook.SkyHookProxyFixture.should_be_able_to_get_artist_detail"
  ]
  ++ lib.optionals stdenvNoCC.buildPlatform.isDarwin [
    # flaky on darwin
    "NzbDrone.Core.Test.NotificationTests.TraktServiceFixture.should_add_collection_movie_if_valid_mediainfo"
    "NzbDrone.Core.Test.NotificationTests.TraktServiceFixture.should_format_audio_channels_to_one_decimal_when_adding_collection_movie"
  ];
  passthru = {
    tests.smoke-test = nixosTests.lidarr;
  };

  meta = {
    description = "Looks and smells like Sonarr but made for music";
    homepage = "https://github.com/Lidarr/Lidarr/tree/plugins";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ racci ];
    mainProgram = "lidarr-plugins";
    platforms = lib.platforms.all;
  };
}
