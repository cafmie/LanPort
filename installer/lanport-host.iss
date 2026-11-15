; LanPort Host / Main PC installer (Inno Setup 6)
; Compile on Windows after PyInstaller: ISCC.exe installer\lanport-host.iss
; Optional: ISCC.exe /DMyAppVersion=0.5.0 installer\lanport-host.iss

#ifndef MyAppVersion
  #define MyAppVersion "0.5.0"
#endif

#define MyAppName "LanPort"
#define MyAppPublisher "cafmie"
#define MyAppURL "https://github.com/cafmie/LanPort"
#define MyAppExeName "LanPort.exe"
#define MyRoleLabel "Host"

[Setup]
AppId={{8F3C2A1B-6D4E-4F91-9B2A-A1B2C3D4E5F0}
AppName={#MyAppName} ({#MyRoleLabel})
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}/releases
DefaultDirName={localappdata}\LanPort\Host
DefaultGroupName=LanPort
DisableProgramGroupPage=yes
OutputDir=..\dist\installers
OutputBaseFilename=LanPort-Host-Setup
SetupIconFile=..\assets\icon.ico
UninstallDisplayIcon={app}\icon.ico
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
VersionInfoVersion={#MyAppVersion}.0
VersionInfoProductName={#MyAppName} ({#MyRoleLabel})
VersionInfoCompany={#MyAppPublisher}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\dist\LanPort.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\packaging\run-host.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\assets\icon.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\packaging\README-host.txt"; DestDir: "{app}"; Flags: ignoreversion isreadme

[Icons]
Name: "{group}\LanPort (Host)"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--role main --name ""Main PC"""; IconFilename: "{app}\icon.ico"; WorkingDir: "{app}"
Name: "{group}\Uninstall LanPort (Host)"; Filename: "{uninstallexe}"
Name: "{autodesktop}\LanPort (Host)"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--role main --name ""Main PC"""; IconFilename: "{app}\icon.ico"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Parameters: "--role main --name ""Main PC"""; Description: "Launch LanPort (Host)"; Flags: nowait postinstall skipifsilent
