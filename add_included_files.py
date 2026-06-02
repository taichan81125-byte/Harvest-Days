import json, re

def update_yyp():
    path = 'd:/Harvest-Days/HarvestDays.yyp'
    with open(path, 'r', encoding='utf-8') as f:
        s = f.read()
        
    # Xóa dấu phẩy thừa
    s = re.sub(r',\s*}', '}', s)
    s = re.sub(r',\s*\]', ']', s)
    
    data = json.loads(s)
    
    if 'IncludedFiles' not in data:
        data['IncludedFiles'] = []
        
    existing_files = [f.get('name') for f in data['IncludedFiles']]
    
    files_to_add = [
        'xuan.png', 'ha.png', 'thu.png', 'dong.png',
        'city_xuan.png', 'city_ha.png', 'city_thu.png', 'city_dong.png'
    ]
    
    added_count = 0
    for file_name in files_to_add:
        if file_name not in existing_files:
            new_file = {
                "$GMIncludedFile": "",
                "%Name": file_name,
                "CopyToMask": -1,
                "filePath": "datafiles",
                "name": file_name,
                "resourceType": "GMIncludedFile",
                "resourceVersion": "2.0"
            }
            data['IncludedFiles'].append(new_file)
            added_count += 1
            print(f'Added {file_name} to yyp')
            
    if added_count > 0:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)
        print('Successfully updated HarvestDays.yyp')
    else:
        print('All files already exist in HarvestDays.yyp')

update_yyp()
