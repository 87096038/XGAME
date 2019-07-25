using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using XLua;

namespace LuaDLL
{ 
    public partial class Lua
    { 
        [DllImport(pb, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_rapidjson(System.IntPtr L);

        [MonoPInvokeCallback(typeof(pb.))]
        public static int LoadLuaProfobuf(System.IntPtr L)
        {
            return luaopen_pb(L);
        }
    }
}
