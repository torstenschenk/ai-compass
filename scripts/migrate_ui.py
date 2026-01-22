import os
import re
import glob

SOURCE_DIR = r"d:\SpicedProjects\Projects\ai-compass\IMPLEMENTATION\ui"
DEST_DIR = r"d:\SpicedProjects\Projects\ai-compass\Application_Prototype\mvp_v1\frontend\src\components\ui"

if not os.path.exists(DEST_DIR):
    os.makedirs(DEST_DIR)

def convert_tsx_to_jsx(content):
    # Remove interface and type definitions
    content = re.sub(r'export interface [^\{]*\{[^\}]*\}', '', content, flags=re.MULTILINE|re.DOTALL)
    content = re.sub(r'interface [^\{]*\{[^\}]*\}', '', content, flags=re.MULTILINE|re.DOTALL)
    content = re.sub(r'type [^=]*=.*;', '', content, flags=re.MULTILINE|re.DOTALL)
    
    # Remove type annotations in function args e.g. ({ className, ...props }: React.ComponentProps<"div">)
    # This is tricky with regex. A simpler approach for these specific files might be to generic replace.
    # Most shadcn components use `({ className ... }: Type)` pattern.
    
    # Remove `: Type` 
    # rigorous regex is hard, but let's try some common patterns in shadcn
    
    # Remove generic type parameters <T>
    content = re.sub(r'function \w+<[^>]+>', lambda m: m.group(0).split('<')[0], content)
    
    # Remove return type annotations (e.g. ): React.FC => )
    # Not very common in the component defs themselves in typical shadcn
    
    # Remove prop type annotations
    # Match: }: SomeType)
    content = re.sub(r'\}: [^)]+\)', '})', content)
    
    # Match: (props: SomeType)
    content = re.sub(r'\(props: [^)]+\)', '(props)', content)
    
    # Match: ref: React.Ref<...>
    content = re.sub(r'ref: [^,)]+', 'ref', content)
    
    # Remove "asChild" prop type
    # content = re.sub(r'asChild\?: boolean', 'asChild', content)
    
    # Remove imports that are type-only if possible (hard to distinguish without parser)
    # But usually harmless in JS if ignored, or might cause error if importing non-existent type files.
    # shadcn usually imports types from 'class-variance-authority' or 'react'.
    
    # Remove `React.ComponentProps<"div">` etc inside the arg list if missed above
    # Regex to aggressively strip types inside `function Comp(...)` is risky.
    # Instead, let's just strip everything after colon until comma or closing paren/brace? No, too dangerous.
    
    # Let's handle the specific pattern found in card.tsx:
    # function Card({ className, ...props }: React.ComponentProps<"div">)
    content = re.sub(r'\}: [A-Za-z0-9_\.]+(?:<[^>]+>)?\)', '})', content)
    
    # Also handle `React.forwardRef<...>(...)`
    content = re.sub(r'React\.forwardRef<[^>]+>', 'React.forwardRef', content)
    
    # Handle `export { ... }` - usually fine.
    
    return content

files = glob.glob(os.path.join(SOURCE_DIR, "*.tsx"))
# Also .ts files (utils.ts)
files += glob.glob(os.path.join(SOURCE_DIR, "*.ts"))

print(f"Found {len(files)} files to migrate.")

for file_path in files:
    filename = os.path.basename(file_path)
    if filename == "utils.ts":
        out_name = "utils.js"
    else:
        out_name = filename.replace(".tsx", ".jsx")
    
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    # Convert
    js_content = convert_tsx_to_jsx(content)
    
    # Clean up empty lines
    js_content = re.sub(r'\n\s*\n\s*\n', '\n\n', js_content)
    
    out_path = os.path.join(DEST_DIR, out_name)
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(js_content)
    
    print(f"Propagated {filename} -> {out_name}")

print("Migration complete.")
