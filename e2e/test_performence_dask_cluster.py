import os
import sys
import time
import dask.array as da
import dask.dataframe as dd
from dask.distributed import Client


if __name__ == "__main__":
    args = sys.argv[1:]
    assert (
        args and len(args) > 1
    ), "need two arguments: address which is scheduler address, size which is integer"
    print(f"args: {args}")
    address = args[0]
    size = int(args[1])
    print(f"address: {address}")
    print(f"size: {size}")

    pid = os.getpid()
    print(f"Driver pid: {pid}")

    client = Client(address=address)

    da1 = da.random.random((size, 2), chunks=(1, 2))
    df1 = dd.from_dask_array(da1, columns=list("AB"))
    s = time.time()
    r1 = df1.compute()
    e = time.time()
    print(f"cost: {e - s}s")
    print("r1:\n", r1)
