import os
import sys
import time
import mars
import mars.tensor as mt
import mars.dataframe as md

if __name__ == "__main__":
    args = sys.argv[1:]
    assert (
        args and len(args) > 1
    ), "need two arguments: address which is string, size which is integer"
    print(f"args: {args}")
    address = args[0]
    size = int(args[1])
    print(f"address: {address}, size: {size}")

    pid = os.getpid()
    print(f"Driver pid: {pid}")

    session = mars.new_session(f"http://{address}")

    da1 = mt.random.random((size, 2), chunk_size=(1, 2))
    df1 = md.DataFrame(da1, columns=list("AB"))
    s = time.time()
    r1 = df1.execute()
    e = time.time()
    print(f"cost: {e - s}s")
    print("r1:\n", r1)

    mars.stop_server()
