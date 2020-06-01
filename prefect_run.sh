trap 'kill $(jobs -p)' EXIT

# Start local Dask cluster
nohup dask-scheduler --dashboard-address :8086 &
nohup dask-worker localhost:8786 --nthreads 4 &
nohup dask-worker localhost:8786 --nthreads 4 &

dask_cluster_address='tcp://127.0.0.1:8786'
prefect_user_token=$(cat /var/run/secrets/user_credentials/prefectuser)
prefect_runner_token=$(cat /var/run/secrets/user_credentials/prefectrunner)

# Tell Prefect to use local Dask cluster
export PREFECT__ENGINE__EXECUTOR__DEFAULT_CLASS=prefect.engine.executors.DaskExecutor
export PREFECT__ENGINE__EXECUTOR__DASK__ADDRESS=$dask_cluster_address

prefect auth login -t $prefect_user_token
python flows.py
prefect agent start -t $prefect_runner_token