# coding=utf8

import paramiko, logging

def exec_command_over_ssh(ip='', port='22', username='', password='', cmd=''):
	try:
		ssh_client = paramiko.SSHClient()
		ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
		ssh_client.connect(ip, port, username, password)
		std_in, std_out, std_err = ssh_client.exec_command(cmd)
		std_out = std_out.read()
		ssh_client.close()
		print (std_out)
		return (std_out)
	except Exception as e:
		logging.error(e)
		return None

if __name__=='__main__':
    print ('123')
    exec_command_over_ssh('192.168.0.77', 22, 'root', '111111', 'pwd')