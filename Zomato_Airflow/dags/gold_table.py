from airflow.sdk import dag, task

@dag(
    dag_id="gold_table",
)
def gold_table():
    @task
    def gold_table_create():
        return "Creating gold table in databricks"

    @task.bash
    def gold_snapshot_command():
        return "cd /opt/airflow/zomato_porject_dbt && dbt snapshot"

    @task.bash
    def gold_table_command():
        return "cd /opt/airflow/zomato_porject_dbt && dbt run --select gold"
    
    @task
    def gold_table_complete():
        return "Gold table creation in databricks completed"

    task1 = gold_table_create()
    task2 = gold_snapshot_command()
    task3 = gold_table_command()
    task4 = gold_table_complete()

    task1 >> task2 >> task3 >> task4

gold_table()