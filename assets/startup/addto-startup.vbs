' 
' Run as Administrator and UAC
' ����ű���windows7����ϵͳ��������
' ��XP���������⣺�ᵯ��һ��"�������"�Ի���
'   "�����ҵļ���������ݲ���δ��Ȩ����ĻӰ��"Ĭ���ǹ�ѡ�ģ���ȡ����Ȼ��ȷ�����С�������
' (ע��2016���ˣ����ں�������XP�˰ɡ�)
Option Explicit
Dim wsh, fso, ObjShell, BtnCode, ScriptDir, FilePath, link

Set wsh = WScript.CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' ����
' https://groups.google.com/forum/#!topic/microsoft.public.scripting.vbscript/Fb-YibxZ2x8
' https://stackoverflow.com/questions/13296281/permission-elevation-from-vbscript
'
If WScript.Arguments.length = 0 Then
    Set ObjShell = CreateObject("Shell.Application")
    ObjShell.ShellExecute "wscript.exe", """" & _
                            WScript.ScriptFullName & """" &_
                            " RunAsAdministrator", , "runas", 1
    WScript.Quit
End If


Function CreateShortcut(FilePath)
    Set wsh = WScript.CreateObject("WScript.Shell")
    Set link = wsh.CreateShortcut(wsh.SpecialFolders("Startup") + "\goproxy.lnk")
    link.TargetPath = FilePath
    link.Arguments = ""
    link.WindowStyle = 7
    link.Description = "GoProxy"
    link.WorkingDirectory = wsh.CurrentDirectory
    link.Save()
End Function

BtnCode = wsh.Popup("�Ƿ� goproxy.exe ���뵽�����(���Ի��� 6 �����ʧ)", 6, "GoProxy �Ի���", 1+32)
If BtnCode = 1 Then
    ScriptDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
    FilePath = ScriptDir + "\goproxy-gui.exe"
    If Not fso.FileExists(FilePath) Then
        wsh.Popup "��ǰĿ¼�²����� goproxy-gui.exe ", 5, "GoProxy �Ի���", 16
        WScript.Quit
    End If
    CreateShortcut(FilePath)
    wsh.Popup "�ɹ����� GoProxy ��������", 5, "GoProxy �Ի���", 64
End If
