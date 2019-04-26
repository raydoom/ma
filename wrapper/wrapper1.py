def one(func):
    print('----1----')
    def two():
        print('----2----')
        func()
    return two

def a(func):
    print('----a----')
    def b():
        print('----b----')
        func()
    return b

@one
@a
def demo():
    print('----3----')

demo()