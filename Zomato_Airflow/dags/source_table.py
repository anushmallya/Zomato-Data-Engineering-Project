from airflow.sdk import dag, task

@dag(
    dag_id="source_table",
)
def source_table():
    @task
    def clean():
        return "Deleting the folders in zomato_porject_dbt"

    @task.bash
    def clean_command():
        return "rm -rf /opt/airflow/zomato_porject_dbt/target && rm -rf /opt/airflow/zomato_porject_dbt/logs"

    @task
    def clean_complete():
        return "Deleting the folders in zomato_porject_dbt completed"
    
    @task
    def source_table_create():
        return "Creating source table in databricks"

    @task.bash
    def source_table_command():
        return "cd /opt/airflow/zomato_porject_dbt && dbt run --select sources"

    @task
    def source_table_complete():
        return "Source table creation in databricks completed"

    task1 = clean()
    task2 = clean_command()
    task3 = clean_complete()
    task4 = source_table_create()
    task5 = source_table_command()
    task6 = source_table_complete()

    task1 >> task2 >> task3 >> task4 >> task5 >> task6

source_table()