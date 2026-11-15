; LanPort Handheld / Sub-PC installer (Inno Setup 6)
; Compile on Windows after PyInstaller: ISCC.exe installer\lanport-handheld.iss
; Optional: ISCC.exe /DMyAppVersion=0.5.0 installer\lanport-handheld.iss

#ifndef MyAppVersion
  #define MyAppVersion "0.5.0"
#endif

#define MyAppName "LanPort"
#define MyAppPublisher "cafmie"
#define MyAppURL "https://github.com/cafmie/LanPort"
#define MyAppExeName "LanPort.exe"
#define MyRoleLabel "Handheld"
#define MyRoleArgs "--role handheld --name Ally"

[Setup]
AppId={{8F3C2A1B-6D4E-4F91-9B2A-A1B2C3D4E5F1}
AppName={#MyAppName} ({#MyRoleLabel})
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}/releases
DefaultDirName={localappdata}\LanPort\Handheld
DefaultGroupName=LanPort
DisableProgramGroupPage=yes
OutputDir=..\dist\installers
OutputBaseFilename=LanPort-Handheld-Setup
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
Source: "..\run-handheld.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\assets\icon.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\packaging\README-handheld.txt"; DestDir: "{app}"; Flags: ignoreversion isreadme

[Icons]
Name: "{group}\LanPort (Handheld)"; Filename: "{app}\{#MyAppExeName}"; Parameters: {#MyRoleArgs}; IconFilename: "{app}\icon.ico"; WorkingDir: "{app}"
Name: "{group}\Uninstall LanPort (Handheld)"; Filename: "{uninstallexe}"
Name: "{autodesktop}\LanPort (Handheld)"; Filename: "{app}\{#MyAppExeName}"; Parameters: {#MyRoleArgs}; IconFilename: "{app}\icon.ico"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Parameters: {#MyRoleArgs}; Description: "Launch LanPort (Handheld)"; Flags: nowait postinstall skipifsilent
