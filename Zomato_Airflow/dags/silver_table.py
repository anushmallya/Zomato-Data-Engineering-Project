from airflow.sdk import dag, task

@dag(
    dag_id="silver_table",
)
def silver_table():
    @task
    def silver_table_create():
        return "Creating silver table in databricks"

    @task.bash
    def silver_table_command():
        return "cd /opt/airflow/zomato_porject_dbt && dbt build --select silver"

    @task
    def silver_table_complete():
        return "Silver table creation in databricks completed"

    task1 = silver_table_create()
    task2 = silver_table_command()
    task3 = silver_table_complete()

    task1 >> task2 >> task3

silver_table()