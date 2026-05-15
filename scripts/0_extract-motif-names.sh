mkdir -p 0_names

ls ../data/*.meme | while read id
do
file_name=$(basename "$id")
grep '^MOTIF' $id > ./0_names/${file_name%.meme}.names.txt
done