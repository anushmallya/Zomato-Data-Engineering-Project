from airflow.sdk import dag, task
from airflow.providers.standard.operators.trigger_dagrun import TriggerDagRunOperator

@dag(
    dag_id="zomato_pipeline",
)
def zomato_pipeline():
    @task
    def start_pipeline():
        return "Starting Zomato data pipeline"

    ingestion = TriggerDagRunOperator(
        task_id="Start_ingestion",
        trigger_dag_id="data_to_databricks",
        wait_for_completion=True,
    )

    source_table = TriggerDagRunOperator(
        task_id="Start_source_table",
        trigger_dag_id="source_table",
        wait_for_completion=True,
    )

    bronze_table = TriggerDagRunOperator(
        task_id="Start_bronze_table",
        trigger_dag_id="bronze_table",
        wait_for_completion=True,
    )

    silver_table = TriggerDagRunOperator(
        task_id="Start_silver_table",
        trigger_dag_id="silver_table",
        wait_for_completion=True,
    )

    gold_table = TriggerDagRunOperator(
        task_id="Start_gold_table",
        trigger_dag_id="gold_table",
        wait_for_completion=True,
    )

    @task
    def end_pipeline():
        return "Zomato data pipeline completed"

    task1 = start_pipeline()
    task2 = ingestion
    task3 = source_table
    task4 = bronze_table
    task5 = silver_table
    task6 = gold_table
    task7 = end_pipeline()

    task1 >> task2 >> task3 >> task4 >> task5 >> task6 >> task7

zomato_pipeline()