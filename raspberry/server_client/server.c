#include<stdio.h>
#include <sys/socket.h>

SOCKET recvSock,WinSocket,slisten;
WSADATA WSAData;
SOCKADDR_IN Acceptor;
SOCKADDR_IN Connector;
int TypeOfCon;
int Initialise();
SOCKET ListenSocket();
int RecvBuff(BYTE * RecdBuffer,int size);
void Close();
unsigned char * RecdBuffer;

int main()
{
int flag;
flag = Initialise();
slisten= ListenSocket();
flag = RecvBuff(RecdBuffer,20);
Close();
return 1;
}

int Initialise()
{
WSAStartup (MAKEWORD(1,1), &WSAData);
WinSocket = socket (AF_INET/*2*/, SOCK_STREAM/*1*/, 0);
recvSock = socket (AF_INET/*2*/, SOCK_STREAM/*1*/, 0);
return 1;
}

SOCKET ListenSocket()
{
int error;
int sizeofaddr;
sizeofaddr = sizeof(Acceptor);

/*BOOL mcast ;
mcast= TRUE;*/

Acceptor.sin_addr.S_un.S_addr = htonl(INADDR_ANY);
Acceptor.sin_family = AF_INET;
Acceptor.sin_port = 9999;

bind(WinSocket,(const SOCKADDR *)&Acceptor,sizeof(Acceptor));
error = GetLastError();
if(error)
{
return 0;
}

listen(WinSocket,1);
error = GetLastError();
if(error)
{
return 0;
}
recvSock = accept((SOCKET)WinSocket,(SOCKADDR
*)&Acceptor,&sizeofaddr);

error = GetLastError();
if(error)
{
return 0;
}
return recvSock;

}

int RecvBuff(BYTE * Buffer,int size)
{
int amount,error;

amount = recv(recvSock,(char *)Buffer,size,0);
error = GetLastError();
if(error)
{
return 0;
}
else
return 1;
}

void Close()
{
closesocket(WinSocket);
closesocket(recvSock);
}
