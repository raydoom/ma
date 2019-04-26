# coding=utf8

class Ma:
    def __init__(self):
        self.a = 2

class Ma1(Ma):
    def printma(self):
        b = 2
        print (self.a)

c = Ma1()
c.printma()