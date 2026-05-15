import csv
import sys
import os
import glob

# ===== 配置区域 =====
CSV_MAPPING = '../Consistent-annotation-for-all-fly-motif-database.csv'
INPUT_DIR = '../data'          # 存放原始 meme 文件的目录
OUTPUT_DIR = '../data_updated' # 输出目录（自动创建）
# ===================

# 1. 读取 CSV 映射，构建 motif名称（去掉"MOTIF "后） -> 组合字符串 的字典
raw_to_combined = {}
with open(CSV_MAPPING, 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    fake_count = 1
    for row in reader:
        source = row['source'].strip()
        fbgn = row['FBgn'].strip()
        symbol = row['Symbol'].strip()
        raw = row['raw'].strip()
        # 去除开头的 "MOTIF "（如果存在），得到 motif 标识（可能包含空格）
        if raw.startswith('MOTIF '):
            motif_id = raw[6:].strip()
        else:
            motif_id = raw
        combined = f"{source}_{fbgn}_{symbol}_{fake_count}"
        raw_to_combined[motif_id] = combined
        fake_count+=1

print(f"已加载 {len(raw_to_combined)} 个 motif 映射", file=sys.stderr)
print("示例映射键（前5个）:", list(raw_to_combined.keys())[:5], file=sys.stderr)

# 2. 确保输出目录存在
os.makedirs(OUTPUT_DIR, exist_ok=True)

# 3. 查找所有 .meme 文件
meme_files = glob.glob(os.path.join(INPUT_DIR, '*.meme'))
print(f"找到 {len(meme_files)} 个 meme 文件", file=sys.stderr)

# 4. 逐个处理
for input_path in meme_files:
    basename = os.path.basename(input_path)
    output_path = os.path.join(OUTPUT_DIR, basename)
    
    print(f"处理: {basename}", file=sys.stderr)
    
    with open(input_path, 'r', encoding='utf-8') as infile, \
         open(output_path, 'w', encoding='utf-8') as outfile:
        for line in infile:
            if line.startswith('MOTIF '):
                # 提取 MOTIF 之后的所有内容作为 motif 标识（去除首尾空格）
                motif_id = line[6:].strip()   # line[6:] 去掉 "MOTIF "
                if motif_id in raw_to_combined:
                    new_name = raw_to_combined[motif_id]
                    # 将整行替换为 "MOTIF " + 新名称 + 原行末尾换行符
                    new_line = f"MOTIF {new_name}\n"
                    outfile.write(new_line)
                else:
                    print(f"  警告: Motif '{motif_id}' 未找到映射，保持原样", file=sys.stderr)
                    outfile.write(line)   # 保留原行
            else:
                outfile.write(line)
    
    print(f"  已写入: {output_path}", file=sys.stderr)

print("全部处理完成！", file=sys.stderr)