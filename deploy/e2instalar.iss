; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
AppName=Enterprise Plus
AppVerName=Enterprise Plus
AppPublisher=decisao.net
AppPublisherURL=http://www.decisao.net
AppSupportURL=http://www.decisao.net/contato
AppUpdatesURL=http://www.decisao.net/enterprise
DefaultDirName=C:\enterprise\local
DisableDirPage=yes
DefaultGroupName=Enterprise Plus
DisableProgramGroupPage=yes
OutputDir=C:\enterprise\instalador
OutputBaseFilename=e2instalar

[Tasks]
; NOTE: The following entry contains English phrases ("Create a desktop icon" and "Additional icons"). You are free to translate them into another language if required.
Name: "desktopicon"; Description: "Criar �cone na �rea de trabalho"; GroupDescription: "�cones:"
; NOTE: The following entry contains English phrases ("Create a Quick Launch icon" and "Additional icons"). You are free to translate them into another language if required.
Name: "quicklaunchicon"; Description: "Criar �cone na barra de tarefas"; GroupDescription: "�cones:"; Flags: unchecked

[Files]
Source: "C:\enterprise\teste\enterprise.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\connect.ini"; DestDir: "{app}"; Flags: onlyifdoesntexist
Source: "C:\enterprise\teste\language.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Windows\SysWOW64\midas.dll"; DestDir: "{app}"; Flags: sharedfile regserver
Source: "C:\enterprise\teste\e2admrep.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\NFPaulista.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\NFPaulista32Dll.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Program Files (x86)\Embarcadero\RAD Studio\8.0\bin\borlndmm.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\GDS32.DLL"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\fbclient.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Windows\SysWOW64\dbexpida.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\gbak.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\gfix.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\isql.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\nbackup.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\BemaFI32.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\BemaFI32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\BemaMFD.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\BemaMFD2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\enterprise\teste\Daruma32.dll"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\Enterprise"; Filename: "{app}\enterprise.exe"; WorkingDir: "{app}"
Name: "{userdesktop}\Enterprise"; Filename: "{app}\enterprise.exe"; Tasks: desktopicon; WorkingDir: "{app}"
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Enterprise"; Filename: "{app}\enterprise.exe"; WorkingDir: "{app}"; Tasks: quicklaunchicon

[Run]
; NOTE: The following entry contains an English phrase ("Launch"). You are free to translate it into another language if required.
Filename: "{app}\enterprise.exe"; Description: "Abrir o Enterprise"; WorkingDir: "{app}"; Flags: nowait postinstall skipifsilent
