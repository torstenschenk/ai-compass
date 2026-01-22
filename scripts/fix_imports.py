import os
import re
import glob

TARGET_DIR = r"d:\SpicedProjects\Projects\ai-compass\Application_Prototype\mvp_v1\frontend\src\components\ui"

def fix_imports_in_file(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    # Regex to match @x.y.z immediately before a quote
    # tailored for import sources like "...@1.2.3"
    # We want to remove the @1.2.3 part
    
    # Pattern: Match @ followed by digits.digits.digits
    # Lookahead for quote to ensure we are inside an import string (rough heuristic but safe for these files)
    new_content = re.sub(r'@[0-9]+\.[0-9]+\.[0-9]+(?=["\'])', '', content)
    
    if content != new_content:
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(new_content)
        print(f"Fixed imports in {os.path.basename(file_path)}")

files = glob.glob(os.path.join(TARGET_DIR, "*.jsx"))
# Also check js files just in case
files += glob.glob(os.path.join(TARGET_DIR, "*.js"))

print(f"Scanning {len(files)} files...")

for file_path in files:
    fix_imports_in_file(file_path)

print("Import fix complete.")
