import socket
HOST='119.29.76.253'
PORT=5000
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)      
s.connect((HOST,PORT))       
while 1:
       cmd=raw_input("Please input cmd:")
       print cmd
       try:       
         s.sendall(cmd)
       except socket.error,msg:
         print str(msg[0])+'Messgae'+msg[1]      
       data=s.recv(1024)     
       print data         
s.close()   
