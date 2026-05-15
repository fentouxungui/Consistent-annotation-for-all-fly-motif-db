#!/usr/bin/env python3
"""
OnTheFly基因信息爬虫脚本
从CSV文件读取ID，逐个搜索OnTheFly网站，将结果保存到Excel
"""

import requests
from bs4 import BeautifulSoup
import pandas as pd
import time
from tqdm import tqdm

# 配置
BASE_URL = "https://bhapp.c2b2.columbia.edu/OnTheFly/cgi-bin/TF_search.php"
CSV_FILE = "OnTheFly_2014_Drosophila-for-flybase-batchdownload-2.csv"
OUTPUT_FILE = "OnTheFly_search_results-2.xlsx"

# 请求头
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

# 跳过SSL证书验证（仅用于学术研究目的）
VERIFY_SSL = False

# 禁用SSL警告
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def search_keyword(keyword):
    """
    搜索关键词并返回结果

    Args:
        keyword: 搜索的关键词

    Returns:
        list: 搜索结果列表，每个结果是一个字典
    """
    if pd.isna(keyword) or keyword == "NA" or str(keyword).strip() == "":
        return []

    data = {
        "keyword_search": keyword,
        "submitted": "yes"
    }

    try:
        response = requests.post(BASE_URL, data=data, headers=HEADERS, timeout=30, verify=VERIFY_SSL)
        response.raise_for_status()
        return parse_results(response.text, keyword)
    except Exception as e:
        print(f"搜索 '{keyword}' 时出错: {e}")
        return []

def parse_results(html, keyword):
    """
    解析搜索结果HTML

    Args:
        html: HTML字符串
        keyword: 搜索的关键词

    Returns:
        list: 解析后的结果列表
    """
    soup = BeautifulSoup(html, 'html.parser')
    results = []

    # 查找结果表格
    table = soup.find('table')

    if not table:
        return results

    rows = table.find_all('tr')

    # 跳过表头
    for i, row in enumerate(rows[1:], 1):
        cells = row.find_all('td')
        if len(cells) >= 8:
            result = {
                "Keyword": keyword,
                "Uniprot_Name": cells[1].get_text(strip=True),
                "Uniprot_Accession": cells[2].get_text(strip=True),
                "Protein_Name": cells[3].get_text(strip=True),
                "Gene": cells[4].get_text(strip=True),
                "Gene_Name": cells[5].get_text(strip=True),
                "Symbol": cells[6].get_text(strip=True),
                "Length": cells[7].get_text(strip=True),
                "Reviewed": cells[8].get_text(strip=True)
            }
            results.append(result)

    return results

def read_csv_ids(file_path):
    """
    从CSV文件读取ID列表

    Args:
        file_path: CSV文件路径

    Returns:
        list: 去重后的ID列表
    """
    df = pd.read_csv(file_path)
    if 'ID' in df.columns:
        # 过滤掉NA和空值
        ids = df['ID'].dropna()
        ids = ids[ids != "NA"]
        ids = ids[ids.str.strip() != ""]
        # 去重但保持顺序
        seen = set()
        unique_ids = []
        for idx in ids:
            if idx not in seen:
                seen.add(idx)
                unique_ids.append(idx)
        return unique_ids
    else:
        raise ValueError("CSV文件中没有找到'ID'列")

def main():
    print("开始爬取OnTheFly基因信息...")

    # 读取CSV中的ID
    print(f"正在读取 {CSV_FILE}...")
    keywords = read_csv_ids(CSV_FILE)
    print(f"找到 {len(keywords)} 个唯一ID")

    # 搜索所有关键词
    all_results = []

    with tqdm(total=len(keywords), desc="搜索进度") as pbar:
        for keyword in keywords:
            results = search_keyword(keyword)
            all_results.extend(results)

            # 更新进度条描述
            if results:
                pbar.set_postfix_str(f"{keyword}: {len(results)}个结果")
            else:
                pbar.set_postfix_str(f"{keyword}: 无结果")
            pbar.update(1)

            # 延迟，避免请求过快
            time.sleep(0.5)

    print(f"\n搜索完成！共找到 {len(all_results)} 条结果")

    # 保存到Excel
    if all_results:
        print(f"正在保存到 {OUTPUT_FILE}...")
        df = pd.DataFrame(all_results)

        # 创建一个ExcelWriter对象
        with pd.ExcelWriter(OUTPUT_FILE, engine='openpyxl') as writer:
            df.to_excel(writer, index=False, sheet_name='Results')

            # 调整列宽
            worksheet = writer.sheets['Results']
            for idx, col in enumerate(df.columns, 1):
                max_length = max(
                    df[col].astype(str).apply(len).max(),
                    len(col)
                )
                worksheet.column_dimensions[chr(64 + idx)].width = min(max_length + 2, 50)

        print(f"结果已保存到 {OUTPUT_FILE}")

        # 显示统计信息
        print("\n统计信息:")
        print(f"  搜索的关键词数: {len(keywords)}")
        print(f"  找到的结果总数: {len(all_results)}")
        print(f"  平均每个关键词的结果数: {len(all_results) / len(keywords):.2f}")
    else:
        print("没有找到任何结果")

if __name__ == "__main__":
    main()