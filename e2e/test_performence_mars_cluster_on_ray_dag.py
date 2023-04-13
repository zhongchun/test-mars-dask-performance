import os
import ray
import sys
import time
import mars
import mars.tensor as mt
import mars.dataframe as md

if __name__ == "__main__":
    args = sys.argv[1:]
    assert args and len(args) > 2, "need 3 arguments: address, redis_password, size"
    print(f"args: {args}")

    address = args[0]  # could be 'auto', or concretely '11.122.207.65:8379'
    redis_password = args[1]
    size = int(args[2])
    total_memory_mb = 8000 * 3 + 2000
    print(f"address: {address}")
    print(f"redis_password: {redis_password}")
    print(f"size: {size}")
    print(f"total_memory_mb: {total_memory_mb}")

    pid = os.getpid()
    print(f"Driver pid: {pid}")

    job_config = ray.job_config.JobConfig(total_memory_mb=total_memory_mb)
    ray.init(address=address, _redis_password=redis_password, job_config=job_config)

    session = mars.new_ray_session(
        backend="ray",
        supervisor_cpu=1,
        worker_cpu=1,
        default=True,
        config={
            "task.default_config.fuse_enabled": False,
        },
    )

    da1 = mt.random.random((size, 2), chunk_size=(1, 2))
    df1 = md.DataFrame(da1, columns=list("AB"))
    s = time.time()
    r1 = df1.execute()
    e = time.time()
    print(f"1. cost: {e - s}s")
    print("r1:\n", r1)

    da1 = mt.random.random((size, 2), chunk_size=(1, 2))
    df1 = md.DataFrame(da1, columns=list("AB"))
    s = time.time()
    r1 = df1.execute()
    e = time.time()
    print(f"2. cost: {e - s}s")
    print("r1:\n", r1)

    mars.stop_server()
    ray.shutdown()
