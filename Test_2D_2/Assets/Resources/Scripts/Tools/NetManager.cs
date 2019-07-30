using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using UnityEngine;

public class NetManager
{
    private TcpClient client;

    private static NetManager instance;
    public static NetManager Instance {
        get
        {
            if (instance == null)
            {
                instance = new NetManager();
            }
            return instance;
        }
    }

    private NetManager()
    {
        client = new TcpClient();
    }
    
    
}
