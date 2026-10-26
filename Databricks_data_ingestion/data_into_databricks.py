
from pathlib import Path
from databricks.sdk import WorkspaceClient

# Local folder containing CSV files
local_csv = Path(
    r"D:\Projects\Projects_data\Zomato\data"
)

# Databricks Unity Catalog Volume
volume_path = "/Volumes/zomato_dep/source/source_data"

print("Script started")
print("Local folder exists:", local_csv.exists())

csv_files = list(local_csv.glob("*.csv"))
print("CSV files found:", len(csv_files))

if not csv_files:
    print("No CSV files found in the local folder.")

else:
    w = WorkspaceClient()

    for i in csv_files:
        remote_csv = f"{volume_path}/{i.name}"
        print(f"Uploading: {i.name}")

        w.files.upload_from(
            file_path=remote_csv,
            source_path=str(i),
            overwrite=True,
        )

        print(f"Uploaded successfully: {remote_csv}")

print("Script finished")
