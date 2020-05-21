import prefect
from prefect import Flow, task
from prefect.schedules import IntervalSchedule
from datetime import timedelta, datetime
from prefect.engine.executors import DaskExecutor
from prefect.environments.execution import RemoteEnvironment

import random
from time import sleep

@task
def inc(x):
    logger = prefect.context.get("logger")
    logger.info(f"Task started: {datetime.now().strftime('%H:%M:%S.%f')}")
    sleep(3)
    return x + 1


@task
def dec(x):
    logger = prefect.context.get("logger")
    logger.info(f"Task started: {datetime.now().strftime('%H:%M:%S.%f')}")
    sleep(3)
    return x - 1


@task
def add(x, y):
    logger = prefect.context.get("logger")
    logger.info(f"Task started: {datetime.now().strftime('%H:%M:%S.%f')}")
    sleep(3)
    return x + y


@task(name="sum")
def list_sum(arr):
    logger = prefect.context.get("logger")
    logger.info(f"Task started: {datetime.now().strftime('%H:%M:%S.%f')}")
    return sum(arr)


with Flow("dask-example") as flow:
    incs = inc.map(x=range(100))
    decs = dec.map(x=range(100))
    adds = add.map(x=incs, y=decs)
    total = list_sum(adds)

flow.register(project_name="Hello Anaconda Enterprise")