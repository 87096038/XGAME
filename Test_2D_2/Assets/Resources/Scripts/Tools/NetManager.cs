using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using UnityEngine;
using XLua;

[LuaCallCSharp]
public class Message
{
    public byte type;
    public byte[] data;
}

[LuaCallCSharp]
public class NetManager
{
    private static NetManager instance;
    public static NetManager Instance
    {
        get
        {
            if (instance == null)
                instance = new NetManager();
            return instance;
        }
    }

    public static Queue<Message> MessageQueue;


    public delegate void Receive(byte type, byte[] data);
    
    private Receive reci;
    
    private const int MAX_BUFFER_LENGTH = 1024;
    private TcpClient client; 
    private NetworkStream NS;
    private byte[] buffer;
    private int receiveTimeout = 10;

    private NetManager()
    {
        MessageQueue = new Queue<Message>();
        reci = Main.Instance.luaEnv.Global.GetInPath<Receive>("NetManager.TCPReceiveMessage"); 
        buffer = new byte[MAX_BUFFER_LENGTH];
        client = new TcpClient();
    }

    public bool Connect(string IP, int port)
    {
        client.Connect(IPAddress.Parse(IP), port);
        if (client.Connected)
        {
            client.ReceiveTimeout = receiveTimeout;
            NS = client.GetStream();
            NS.BeginRead(buffer, 0, MAX_BUFFER_LENGTH, new AsyncCallback(TCPReceivedHandle), client);
            return true;
        }
        return false;
    }

    public void Send(byte type, byte[] data)
    {
        if(data.Length == 0)
            return;
        //长度为data的长度+1
        byte[] length = Util.Int32ToBytes(data.Length+1);
        byte[] sendData = new byte[length.Length + 1 + data.Length];
        System.Buffer.BlockCopy(length, 0, sendData, 0, length.Length);
        sendData[length.Length] = type;
        System.Buffer.BlockCopy(data, 0, sendData, length.Length+1, data.Length);
        if (NS!=null)
        {
            NS.BeginWrite(sendData, 0, sendData.Length, SendDataEnd, NS);
        }
    }
    

    private void TCPReceivedHandle(IAsyncResult ar)
    {
        int recv = 0;  
        try  
        {  
            recv = NS.EndRead(ar);  
        }  
        catch  
        {  
            recv = 0;  
        }
        if (recv == 0)  
        {
            if(NS != null)
                NS.Dispose();
            if(client != null)
                client.Dispose();
            return;
        }
    
        byte[] buff = new byte[recv];
        Buffer.BlockCopy(buffer, 0, buff, 0, recv);
        int currentIndex = 0;
        //获取每个信息
        while (currentIndex < recv)
        {
            //取出长度
            int count = 0, step = 24;
            for (int i = 0; i < 4; i++)
            {
                count += (buff[i+currentIndex]<<step);
                step -= 8;
            }
            byte type = buff[currentIndex + 4];
            byte[] buf = new byte[count-1];
            Buffer.BlockCopy(buff, currentIndex + 5, buf, 0, count-1);
            currentIndex += count + 4;
            OnTCPReceived(type, buf);
        }
        NS.BeginRead(buffer, 0, MAX_BUFFER_LENGTH, new AsyncCallback(TCPReceivedHandle), ar);   
    }


    private void OnTCPReceived(byte _type, byte[] _data)
    {
        //var message = new Message();
        //message.type = _type;
        //message.data = _data;
        //MessageQueue.Enqueue(message);
        reci(_type, _data);
        //MessageQueue.()
    }
    
    private void SendDataEnd(IAsyncResult ar)  
    {  
        NS.EndWrite(ar);
    }
}
