{pkgs}: {
  channel = "stable-23.11";
  packages = [
    pkgs.jdk17
    pkgs.unzip
    pkgs.python310Packages.sdkmanager   # Add sdkmanager here
  ];
  
  idx.extensions = [
    # Add any extensions here if required
  ];
  
  idx.previews = {
    previews = {
      web = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "web-server"
          "--web-hostname"
          "0.0.0.0"
          "--web-port"
          "$PORT"
        ];
        manager = "flutter";
      };
      android = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "android"
          "-d"
          "localhost:5555"
        ];
        manager = "flutter";
      };
    };
  };
}
