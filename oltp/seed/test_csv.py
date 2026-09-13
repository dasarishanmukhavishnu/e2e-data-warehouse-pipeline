# import csv
# from pathlib import Path

# project_root = Path(__file__).resolve().parents[2]
# csv_path = project_root / "data" / "raw" / "olist_customers_dataset.csv"

# with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
#     reader = csv.DictReader(file)
#     print(reader.fieldnames)
#     for row in reader:
#         print(row)
#         break

import csv
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
csv_path = project_root / "data" / "raw" / "olist_order_reviews_dataset.csv"

with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
    reader = csv.DictReader(file)

    print(reader.fieldnames)

    for row in reader:
        print(row)
        break