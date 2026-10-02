import sys
sys.argv=[sys.argv[0]]+sys.argv[1:]
from build import *
def listing(P):
    for n,i in enumerate(P.code): print(n,i)
    print('maxstack',P.maxstack,'consts',P.consts[:12])
if __name__=='__main__':
    listing(protos[int(sys.argv[1])])
