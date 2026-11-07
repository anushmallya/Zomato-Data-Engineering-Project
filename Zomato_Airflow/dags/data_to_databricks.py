from airflow.sdk import dag, task

@dag(
    dag_id="data_to_databricks",
)
def data_to_databricks():
    @task
    def local_to_databricks():
        return "Data ingestion from local to databricks"

    @task.bash
    def command_to_ingest_data():
        return("cd /opt/airflow/databricks_data_ingestion" 
               "&& python -u data_into_databricks.py")

    @task
    def local_to_databricks_complete():
        return "Data ingestion from local to databricks completed"

    task1 = local_to_databricks()
    task2 = command_to_ingest_data()
    task3 = local_to_databricks_complete()

    task1 >> task2 >> task3

data_to_databricks()