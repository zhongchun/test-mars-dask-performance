# README

## Content

```txt
.
├── README.md
├── cluster_dask_e2e_pipeline.sh
├── cluster_mars_on_ray_dag_e2e_pipeline.sh
├── cluster_mars_on_ray_e2e_pipeline.sh
├── cluster_mars_on_ray_general.sh
├── cluster_mars_standard_e2e_pipeline.sh
├── e2e
│   ├── test_performence_dask_cluster.py
│   ├── test_performence_mars_cluster_on_ray.py
│   ├── test_performence_mars_cluster_on_ray_dag.py
│   └── test_performence_mars_cluster_standard.py
├── launch_dask_cluster.sh
├── launch_mars_standard_cluster.sh
├── launch_ray_cluster.sh
└── utils
    └── common.sh

2 directories, 14 files
```

## Env

```shell
Python: 3.7.9

Mars: 0.10.0

Dask: 2022.2.0, distributed: 2022.2.0
```

## How to run

```shell
# 1. Launch a Dask/Mars cluster
sh launch_dask_cluster.sh -t {scheduler|worker|stop} -a {server_address} -w {nworkers}
# or
sh launch_mars_standard_cluster.sh -t {supervisor|worker|stop} -a {server_address}

# 2. Run the test
sh cluster_dask_e2e_pipeline.sh -a {address} -r {round} -s {size}
# or
sh cluster_mars_standard_e2e_pipeline.sh -a {address} -r {round} -s {size}
```