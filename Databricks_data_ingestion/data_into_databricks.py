# This script uploads compressed CSV files from a local folder to a Databricks Unity Catalog Volume.

# Importing pathlib for handling file paths and Databricks SDK for interacting with Databricks workspace
from pathlib import Path 
from databricks.sdk import WorkspaceClient
from databricks.sdk.config import Config

# Local folder containing CSV files
local_csv = Path("/opt/airflow/data")

# Databricks Unity Catalog Volume
volume_path = "/Volumes/zomato_dep/source/source_data"

print("Script started", flush=True)
print("Local folder exists:", local_csv.exists(), flush=True)

csv_files = list(local_csv.glob("*.csv.gz"))
print("CSV files found:", len(csv_files), flush=True)

if not csv_files:
    print("No CSV files found in the local folder.", flush=True)

else:
    w = WorkspaceClient(
        config=Config(
            retry_timeout_seconds=1800,
        )
    )

    for i in csv_files:
        remote_csv = f"{volume_path}/{i.name}"
        file_size = i.stat().st_size / (1024 * 1024)  # Size in MB
        print(f"Uploading: {i.name}", flush=True)
        print(f"File size: {file_size:.2f} MB", flush=True)

        w.files.upload_from(
            file_path=remote_csv,
            source_path=str(i),
            overwrite=True,
            part_size=64 * 1024 * 1024,
            use_parallel= False
        )

        print(f"Uploaded successfully: {remote_csv}")

print("Script finished")

