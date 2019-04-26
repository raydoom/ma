def ma_wrapper1(func):
    def wrapper(*args, **kwargs):
        print ('ma_wrapper1')
        return  func(*args, **kwargs)
    return wrapper

def ma_wrapper2(func):
    def wrapper(*args, **kwargs):
        print ('ma_wrapper2')
        return  func(*args, **kwargs)
    return wrapper

def ma_wrapper3(func):
    def wrapper(*args, **kwargs):
        print ('ma_wrapper3')
        return  func(*args, **kwargs)
    return wrapper

@ma_wrapper1
@ma_wrapper2
@ma_wrapper3
def ma_test_wrapper():
    print ('ma_test_wrapper')


if __name__=="__main__":
    ma_test_wrapper()
