import csv
import re
import time
import urllib3
from pathlib import Path

import requests

# 禁用 SSL 警告（该网站 SSL 证书有问题）
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def extract_name_from_page(protein_id: str) -> str:
    """从 OnTheFly 页面提取 NAME 字段"""
    url = f"https://bhapp.c2b2.columbia.edu/OnTheFly/cgi-bin/motif_entry.php?protein_ID={protein_id}"
    try:
        response = requests.get(url, timeout=10, verify=False)
        response.raise_for_status()

        # 从页面中提取 NAME
        # 格式: "Summary page for ID: OTF0067.1 NAME: BAGP_DROME_B1H from the OnTheFly database"
        pattern = r"NAME:\s*(\S+)"
        match = re.search(pattern, response.text)
        if match:
            return match.group(1)
        return ""
    except Exception as e:
        print(f"Error fetching {protein_id}: {e}")
        return ""


def main():
    input_csv = Path("OnTheFly_gene_lost.csv")
    output_csv = Path("OnTheFly_gene_lost_with_name.csv")

    results = []

    with open(input_csv, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            gene_raw = row["gene_raw"]
            print(f"Processing: {gene_raw}")

            name = extract_name_from_page(gene_raw)
            print(f"  Found NAME: {name}")

            row["OTF_Name"] = name
            results.append(row)

            # 避免请求过快
            time.sleep(0.5)

    # 写入结果
    with open(output_csv, "w", encoding="utf-8", newline="") as f:
        fieldnames = list(results[0].keys())
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(results)

    print(f"\nDone! Results saved to {output_csv}")


if __name__ == "__main__":
    main()