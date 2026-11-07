from airflow.sdk import dag, task

@dag(
    dag_id="bronze_table",
)
def bronze_table():
    @task
    def bronze_table_create():
        return "Creating bronze table in databricks"

    @task.bash
    def bronze_table_command():
        return "cd /opt/airflow/zomato_porject_dbt && dbt run --select bronze"

    @task
    def bronze_table_complete():
        return "Bronze table creation in databricks completed"

    task1 = bronze_table_create()
    task2 = bronze_table_command()
    task3 = bronze_table_complete()

    task1 >> task2 >> task3

bronze_table()