using System;
using System.ComponentModel;
using System.Runtime.InteropServices;

public class RefindNextBoot
{
    [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
    internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr relen);

    [DllImport("kernel32.dll", ExactSpelling = true)]
    internal static extern IntPtr GetCurrentProcess();

    [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
    internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);

    [DllImport("advapi32.dll", SetLastError = true)]
    internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    internal struct TokPriv1Luid
    {
        public int Count;
        public long Luid;
        public int Attr;
    }

    internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
    internal const int TOKEN_QUERY = 0x00000008;
    internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;
    internal const string SE_SYSTEM_ENVIRONMENT_NAME = "SeSystemEnvironmentPrivilege";

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern UInt32 GetFirmwareEnvironmentVariableA(string lpName, string lpGuid, IntPtr pBuffer, UInt32 nSize);

    [DllImport("kernel32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    static extern bool SetFirmwareEnvironmentVariableA(string lpName, string lpGuid, IntPtr pBuffer, UInt32 nSize);

    private static bool SetPrivilege()
    {
        try
        {
            bool retVal;
            TokPriv1Luid tp;
            IntPtr hproc = GetCurrentProcess();
            IntPtr htok = IntPtr.Zero;
            retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
            tp.Count = 1;
            tp.Luid = 0;
            tp.Attr = SE_PRIVILEGE_ENABLED;
            retVal = LookupPrivilegeValue(null, SE_SYSTEM_ENVIRONMENT_NAME, ref tp.Luid);
            retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
            return retVal;
        }
        catch (Exception)
        {
            return false;
        }
    }


    public static string Get()
    {
        if (!RefindNextBoot.SetPrivilege())
        {
            return "Error: Unable to set privilege";
        }
        string s = "";
        UInt32 size = (uint)256;
        int[] array = new int[size];
        UInt32 ret;
        GCHandle handle = default(GCHandle);
        try
        {
            handle = GCHandle.Alloc(array, GCHandleType.Pinned);
            IntPtr pointer = handle.AddrOfPinnedObject();
            ret = GetFirmwareEnvironmentVariableA("PreviousBoot", "{36d08fa7-cf0b-42f5-8f14-68df73ed3740}", pointer, size);
            s = Marshal.PtrToStringAuto(pointer);
        }
        finally
        {
            if (handle.IsAllocated)
            {
                handle.Free();
            }
        }

        if (ret > 0)
        {
            return s;
        }
        else
        {
            string errorMessage = new Win32Exception(Marshal.GetLastWin32Error()).Message;
            return "Error: " + errorMessage;
        }
    }

    public static string Set(string efivar)
    {
        if (!RefindNextBoot.SetPrivilege())
        {
            return "Error: Unable to set privilege";
        }

        // build efivar as per https://gist.github.com/Darkhogg/82a651f40f835196df3b1bd1362f5b8c
        UInt32 size = 4 + (2 * (uint)efivar.Length);
        byte[] buffer = new byte[size];
        for (int i = 0; i < efivar.Length; i++)
        {
            buffer[2 * i] = (byte)efivar[i];
            buffer[(2 * i) + 1] = 0x00;
        }
        buffer[size - 4] = 0x20;
        buffer[size - 3] = 0x00;
        buffer[size - 2] = 0x00;
        buffer[size - 1] = 0x00;

        // Console.Write(BitConverter.ToString(buffer)); // debug

        bool success;
        GCHandle handle = default(GCHandle);
        try
        {
            handle = GCHandle.Alloc(buffer, GCHandleType.Pinned);
            IntPtr pointer = handle.AddrOfPinnedObject();
            success = SetFirmwareEnvironmentVariableA("PreviousBoot", "{36d08fa7-cf0b-42f5-8f14-68df73ed3740}", pointer, size);
        }
        finally
        {
            if (handle.IsAllocated)
            {
                handle.Free();
            }
        }

        if (success)
        {
            return "ok";
        }
        else
        {
            string errorMessage = new Win32Exception(Marshal.GetLastWin32Error()).Message;
            return "Error: " + errorMessage;
        }
    }
}