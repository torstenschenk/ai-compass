import pkg_resources
import re

def parse_requirements(file_path):
    requirements = set()
    try:
        with open(file_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                # Split on comparison operators to get package name
                package_name = re.split(r'[=<>!~]', line)[0].strip().lower()
                if package_name:
                    requirements.add(package_name)
    except FileNotFoundError:
        print(f"File not found: {file_path}")
    return requirements

def check_packages():
    # Get installed packages
    # Use explicit working_set to prevent issues
    installed_packages = {pkg.key: pkg.version for pkg in pkg_resources.working_set}
    
    # Get requirements
    required_packages = parse_requirements('requirements.txt')
    
    missing_from_reqs = []
    
    for pkg_name, version in installed_packages.items():
        if pkg_name not in required_packages:
            missing_from_reqs.append(f"{pkg_name}=={version}")
            
    print(f"Total Installed: {len(installed_packages)}")
    print(f"Total in requirements.txt: {len(required_packages)}")
    
    with open('missing_requirements.txt', 'w') as f:
        for pkg in sorted(missing_from_reqs):
            f.write(pkg + '\n')
    print("List saved to missing_requirements.txt")

if __name__ == "__main__":
    check_packages()
