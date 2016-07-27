#!/usr/bin/env python
# Weiwei Wan, 20160602

from nextage_ros_bridge import nextage_client
from hrpsys import rtm

import bodyinfo

import sys
import commands
import datetime
import SocketServer


class EchoHandler(SocketServer.BaseRequestHandler):

    # data structure: chest, headyaw, headpitch, armright6joints, armleft6joints
    poslimit = [[163, -163], [70, -70], [70, -20], \
                [88, -88], [60, -140], [0, -158], [105, -165], [100, -100], [163, -163], \
                [88, -88], [60, -140], [0, -158], [105, -165], [100, -100], [163, -163]]
    spdlimit = [[130, -130], [150, -150], [250, -250], \
                [172, -172], [133, -133], [229, -229], [150, -150], [250, -250], [300, -300], \
                [172, -172], [133, -133], [229, -229], [150, -150], [250, -250], [300, -300]]
    
    iscalibrated = False
    bufsize = 2048

    def __init__(self, request, client_address, server):
        SocketServer.BaseRequestHandler.__init__(self, request, client_address, server)

    def handle(self):
        while True:
            try:
                request_msg = self.request.recv(self.bufsize)
		if request_msg:
                    print "Message from: %s" % str(self.client_address)
                    print request_msg
                else:
                    continue
                if request_msg == "connect":
                    self.initializerobot()
                elif request_msg == "disconnect":
                    self.finalizerobot()
                    return
                elif request_msg[:12] == "movejoints15":
	    	    # data structure: 3->body, 6->right, 6->left, 1->tm
                    # the values are separated by ","
                    # the char at 12 is ",", the following functions are the same
                    param_strlist = request_msg[13:].split(",")
                    param_list = map(float, param_strlist)
                    self.movejoints15(param_list)
                elif request_msg[:19] == "moverightarmjoints7":
	    	    # data structure: 1->chest 6->armjoints, 1->tm
                    # the values are separated by ","
                    param_strlist = request_msg[20:].split(",")
                    param_list = map(float, param_strlist)
                    self.moverightarmjoints7(param_list)
                elif request_msg[:18] == "moveleftarmjoints7":
	    	    # data structure: 1->chest 6->armjoints, 1->tm
                    # the values are separated by ","
                    param_strlist = request_msg[19:].split(",")
                    param_list = map(float, param_strlist)
                    self.moveleftarmjoints7(param_list)
                elif request_msg[:19] == "moverightarmjoints6":
	    	    # data structure: 6->armjoints, 1->tm
                    # the values are separated by ","
                    param_strlist = request_msg[20:].split(",")
                    param_list = map(float, param_strlist)
                    self.moverightarmjoints6(param_list)
                elif request_msg[:18] == "moveleftarmjoints6":
	    	    # data structure: 6->armjoints, 1->tm
                    # the values are separated by ","
                    param_strlist = request_msg[19:].split(",")
                    param_list = map(float, param_strlist)
                    self.moveleftarmjoints6(param_list)
                elif request_msg[:12] == "moverighttcp":
		    # data structure: 3->xyz, 3->rpy, 1->rate
                    # the values are separated by ","
                    param_strlist = request_msg[13:].split(",")
                    param_list = map(float, param_strlist)
                    self.moverighttcp(param_list)
                elif request_msg[:11] == "movelefttcp":
    		    # data structure: 3->xyz, 3->rpy, 1->rate
                    # the values are separated by ","
                    param_strlist = request_msg[12:].split(",")
                    param_list = map(float, param_strlist)
                    self.movelefttcp(param_list)
		elif request_msg[:9] == "goinitial":
		    param = float(request_msg[10:]);
		    self.goinitial(param);
		elif request_msg[:9] == "rhandgrsp":
		    # the range is from 0 to 100, where 0 is close, 100 is open
		    param = float(request_msg[10:]);
		    self.rhandopen(param);
		elif request_msg[:9] == "lhandgrsp":
		    # the range is from 0 to 100, where 0 is close, 100 is open
		    param = float(request_msg[10:]);
		    self.lhandopen(param);
		elif request_msg[:9] == "resethand":
		    # the old hand is bad, use this commnad to reset
		    self.resethand();
                elif request_msg == "getjoints":
                    self.getjoints()
                elif request_msg == "servoon":
                    self.servoOn()
                elif request_msg == "getrighttcp":
                    self.getrighttcp()
                elif request_msg == "getlefttcp":
                    self.getlefttcp()
                elif request_msg == "shutdown":
                    self.shutdown()
                sys.stdout.flush()
            except Exception, ex:
                print 'e', ex,

    def initializerobot(self):
        print self.iscalibrated
        if not self.iscalibrated:
	    robot.init(robotname="RobotHardware0")
            robot.checkEncoders(option="-overwrite")
            self.iscalibrated = True
	    robot.goInitial(tm=8)
            print self.iscalibrated
	else:
            robot.goInitial(tm=4)
	#sample.servoOff("RHAND", False);
	#sample.servoOff("LHAND", False);
	#sample.servoOn("RHAND", False);
	#sample.servoOn("LHAND", False);
	#sample.rhandClose();
	#sample.lhandClose();
	#sample.rhandOpen();
	#sample.lhandOpen();
        print "Sending feedback..."
        self.request.send("connected!")

    def resethand(self):
	sample.servoOff("RHAND", False);
	sample.servoOff("LHAND", False);
	sample.servoOn("RHAND", False);
	sample.servoOn("LHAND", False);
	sample.rhandClose();
	sample.lhandClose();
	sample.rhandOpen();
	sample.lhandOpen();
        print "Sending feedback..."
        self.request.send("handreseted!")

    def finalizerobot(self):
        #sample.goInitial(4)
        robot.goOffPose()
        print "Sending feedback..."
        self.request.send("disconnected!")

    def movejoints15(self, param_list):
        armpose = [param_list[:3], param_list[3:9], param_list[9:15], joint_list[15:19], joint_list[19:23]]
        mvtime = param_list[15]
        # TODO ensure the parameters are inrange
        sample.setJointAnglesDeg(armpose, mvtime)
        print "Sending feedback..."
        self.request.send("joints15moved!")

    def moverightarmjoints7(self, param_list):
	joint_list = sample.getJointAnglesDeg()
        armpose = [joint_list[:3], joint_list[3:9], joint_list[9:15], joint_list[15:19], joint_list[19:23]]
        mvtime = param_list[7]
        armpose[0][0] = param_list[0]
        armpose[1] = param_list[1:7]
        # TODO ensure the parameters are inrange
        sample.setJointAnglesDeg(armpose, mvtime)
        print "Sending feedback..."
        self.request.send("rightjoints7moved!")

    def moveleftarmjoints7(self, param_list):
	joint_list = sample.getJointAnglesDeg()
        armpose = [joint_list[:3], joint_list[3:9], joint_list[9:15], joint_list[15:19], joint_list[19:23]]
        mvtime = param_list[7]
        armpose[0][0] = param_list[0]
        armpose[2] = param_list[1:7]
        # TODO ensure the parameters are inrange
        sample.setJointAnglesDeg(armpose, mvtime)
        print "Sending feedback..."
        self.request.send("leftjoints7moved!")

    def moverightarmjoints6(self, param_list):
	joint_list = sample.getJointAnglesDeg()
        armpose = [joint_list[:3], joint_list[3:9], joint_list[9:15], joint_list[15:19], joint_list[19:23]]
        mvtime = param_list[6]
        armpose[1] = param_list[:6]
        # TODO ensure the parameters are inrange
        sample.setJointAnglesDeg(armpose, mvtime)
        print "Sending feedback..."
        self.request.send("rightjoints6moved!")

    def moveleftarmjoints6(self, param_list):
	joint_list = sample.getJointAnglesDeg()
        armpose = [joint_list[:3], joint_list[3:9], joint_list[9:15], joint_list[15:19], joint_list[19:23]]
        mvtime = param_list[6]
        armpose[2] = param_list[:6]
        # TODO ensure the parameters are inrange
        sample.setJointAnglesDeg(armpose, mvtime)
        print "Sending feedback..."
        self.request.send("leftjoints6moved!")

    def moverighttcp(self, param_list):
        tcppose = param_list[:6]
        mvrate = param_list[6]
        # TODO ensure the parameters are inrange
        sample.moveR(tcppose[0], tcppose[1], tcppose[2], tcppose[3], tcppose[4], tcppose[5], mvrate)
        print "Sending feedback..."
        self.request.send("rightcpmoved!")

    def movelefttcp(self, param_list):
        tcppose = param_list[:6]
        mvrate = param_list[6]
        # TODO ensure the parameters are inrange
        sample.moveL(tcppose[0], tcppose[1], tcppose[2], tcppose[3], tcppose[4], tcppose[5], mvrate)
        print "Sending feedback..."
        self.request.send("lefttcpmoved!")

    def servoOn(self):
        robot.servoOn()
	print "Sending feedback..."
	self.request.send("servoison!")

    def goinitial(self, param):
        robot.goInitial(tm=param)
	print "Sending feedback..."
	self.request.send("wentinitial!")

    def rhandopen(self, param):
        sample.rhandOpen(param)
	print "Sending feedback..."
	self.request.send("righthandactuated!")

    def lhandopen(self, param):
        sample.lhandOpen(param)
	print "Sending feedback..."
	self.request.send("lefthandactuated!")

    def getjoints(self):
        joint_list = sample.getJointAnglesDeg()
	print joint_list
        print "Sending feedback..."
        self.request.send(",".join(map(str, joint_list)))

    def getrighttcp(self):
        joint_list = sample.getCurrentConfiguration(sample.armR_svc)
	print joint_list
        print "Sending feedback..."
        self.request.send(",".join(map(str, joint_list)))

    def getlefttcp(self):
        joint_list = sample.getCurrentConfiguration(sample.armL_svc)
	print joint_list
        print "Sending feedback..."
        self.request.send(",".join(map(str, joint_list)))

    def shutdown(self):
        if sample.adm_svc != None:
            print "Closing feedback..."
            adm_svc.shutdown("")
            
class ThreadedTCPServer(SocketServer.ThreadingMixIn, SocketServer.TCPServer):
    pass

def simple_tcp_server():
    tcp_server = ThreadedTCPServer(("10.0.1.25", 50305), RequestHandlerClass=EchoHandler)
    try:
        print "server start"
        tcp_server.serve_forever()
    except KeyboardInterrupt, err:
        print "server close"
        tcp_server.server_close()
        
 
if __name__ == "__main__":
    # init network
    # commands.getoutput("sudo /etc/init.d/networking restart")
    # print "network restarted"

    # init robot
    rtm.nshost = "nextage"
    robot = nxc = nextage_client.NextageClient()

    simple_tcp_server()
